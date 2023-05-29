module WorkingDirHelper
  def repo_files_dir(task)
    File.join("lab#{task.lab_id}", "task#{task.id}")
  end

  def download_files_to_working_dir(repo, repo_files_dir, working_dir)
    contents = get_dir_contents_list(repo, repo_files_dir)
    contents.each do |content|
      write_decoded_content content[:content], File.join(working_dir, content[:name])
    end
  end

  def get_dir_contents_list(repo, dir_path)
    content_entries = Octokit.contents(repo, options = { path: dir_path })

    # if dir_path is actually a file path, Octokit returns file content instead of content json
    return [content_entries] unless content_entries.is_a?(Array)

    get_file_contents_for_content_entries(content_entries)
  end

  def get_file_contents_for_content_entries(content_entries)
    contents = []
    content_entries.each do |content_data|
      next unless content_data.key?(:type) && content_data[:type] == "file"

      contents << Octokit.contents(repo, options = { path: content_data[:path] })
    end

    contents
  end

  def write_decoded_content(encoded, filename)
    decoded = Base64.decode64(encoded).force_encoding('utf-8')
    File.open(filename, 'w') do |file|
      file.write(decoded)
    end
  end

  def tests_dir
    File.join(ENV["SANDBOX_DIRECTORY"], "tests")
  end

  def copy_test_file(test_filename, destination_dir)
    source_test_filename = File.join(tests_dir, test_filename)

    destination_test_filename = destination_test_filename(destination_dir, test_filename)

    FileUtils.cp source_test_filename, destination_test_filename

    destination_test_filename
  end

  def destination_test_filename(destination_dir, test_filename)
    destination_tests_dir = prepare_destination_tests_dir(destination_dir)

    File.join(destination_tests_dir, test_filename)
  end

  def prepare_destination_tests_dir(destination_dir)
    destination_tests_dir = File.join(destination_dir, "tests")

    Dir.mkdir destination_tests_dir unless Dir.exist? destination_tests_dir

    destination_tests_dir
  end
end
