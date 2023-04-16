class Task < ApplicationRecord
  validates :index_number, :title, :content_path, :test_filename, presence: true
  has_rich_text :text
  belongs_to :lab
  has_many :task_results
  before_destroy { labs.clear }

  def last_result
    task_results.last
  end

  def run_tests!(username, repo)
    full_test_filename = setup_working_dir(username, repo, repo_files_dir)
    puts full_test_filename
    tests_result_json = run_test_file(full_test_filename)
    task_results.create!(passed_tests: tests_result_json["passed"], total_tests: tests_result_json["total"])
  end

  private

  def repo_files_dir
    File.join("lab#{lab_id}", "task#{id}")
  end

  def setup_working_dir(username, repo, repo_files_dir)
    working_dir = create_working_dir(username)
    download_files_to_working_dir(repo, repo_files_dir, working_dir)
    copy_test_file(working_dir)
  end

  def create_working_dir(username)
    user_dir = setup_user_dir(username)

    working_dir = File.join(user_dir, "lab#{lab_id}_task#{id}")

    FileUtils.rm_rf(working_dir) if Dir.exist? working_dir

    Dir.mkdir(working_dir)

    working_dir
  end

  def setup_user_dir(username)
    base_dir = ENV["SANDBOX_DIRECTORY"]
    user_dir = File.join(base_dir, username)

    Dir.mkdir(user_dir) unless Dir.exist?(user_dir)

    user_dir
  end

  def download_files_to_working_dir(repo, repo_files_dir, working_dir)
    contents = get_dir_contents_list(repo, repo_files_dir)
    contents.each do |content|
      write_decoded_content content[:content], File.join(working_dir, content[:name])
    end
  end

  def get_dir_contents_list(repo, dir_path)
    response = Octokit.contents(repo, options = { path: dir_path })

    return [response] unless response.is_a?(Array)

    contents = []
    response.each do |content_data|
      next unless content_data.key?(:type) && content_data[:type] == "file"

      obj_responce = Octokit.contents(repo, options = { path: content_data[:path] })
      contents << obj_responce
    end

    contents
  end

  def write_decoded_content(encoded, filename)
    decoded = Base64.decode64(encoded).force_encoding('utf-8')
    File.open(filename, 'w') do |file|
      file.write(decoded)
    end
  end

  def copy_test_file(destination_dir)
    src_test_filename = File.join(tests_dir, self.test_filename)

    destination_tests_dir = File.join(destination_dir, "tests")

    Dir.mkdir destination_tests_dir unless Dir.exist? destination_tests_dir

    res_test_filename = File.join(destination_tests_dir, self.test_filename)

    FileUtils.cp src_test_filename, res_test_filename

    res_test_filename
  end

  def tests_dir
    File.join(ENV["SANDBOX_DIRECTORY"], "tests")
  end

  # returns json with fields total, failed, errored, skipped, passed
  def run_test_file(test_file, sandbox_user: nil)
    if sandbox_user
      #res = `sudo -u #{sandbox_user} bundle exec ruby #{test_file}"`
      res, _status = Open3.capture2('sudo', '-u', sandbox_user, 'bundle', 'exec', 'ruby', test_file)
    else
      # res = `bundle exec ruby #{test_file}`
      res, _status = Open3.capture2('bundle', 'exec', 'ruby', test_file)
    end

    res = JSON.parse res
    res["statistics"]
  end
end

