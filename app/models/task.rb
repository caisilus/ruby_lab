class Task < ApplicationRecord
  validates :index_number, :title, :content_path, :test_filename, presence: true
  has_rich_text :text
  belongs_to :lab
  has_many :task_results
  before_destroy { labs.clear }

  def has_results_for_user?(user)
    task_results.where(user: user).count > 0
  end

  def last_result_for_user(user)
    task_results.where(user: user).last
  end

  def setup_task_dir(base_dir)
    task_dir = File.join(base_dir, "lab#{lab_id}_task#{id}")

    FileUtils.rm_rf(task_dir) if Dir.exist? task_dir

    Dir.mkdir(task_dir)

    task_dir
  end

  def run_tests!(test_filename, user)
    tests_result_json = run_test_file(test_filename)
    task_results.create!(passed_tests: tests_result_json["passed"], total_tests: tests_result_json["total"], user: user)
  end

  # returns json with fields total, failed, errored, skipped, passed
  def run_test_file(test_file, sandbox_user: nil)
    if sandbox_user
      res, _status = Open3.capture2('sudo', '-u', sandbox_user, 'bundle', 'exec', 'ruby', test_file)
    else
      res, _status = Open3.capture2('bundle', 'exec', 'ruby', test_file)
    end

    res = JSON.parse res
    res["statistics"]
  end
end

