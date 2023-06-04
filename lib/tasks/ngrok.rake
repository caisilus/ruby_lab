require 'open3'

namespace :ngrok do
  desc "Launches ngrok, then fills env variable DEV_URL and starts rails server"
  task start: :environment do
    Open3.popen2e("ngrok http 3000 --config lib/tasks/ngrok.yml") do |stdin, stdout, status, thread|
      line = stdout.gets
      while line do
        args = line.split(" ")
        line = stdout.gets

        url_arg = args.find {|arg| arg.start_with? "url"}

        next if url_arg.nil?

        url = url_arg.split("=")[1]

        puts "URL: #{url}"

        ENV["DEV_URL"] = url

        system('rails s')
      end
    end
  end
end

