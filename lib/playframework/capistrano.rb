require "playframework/capistrano/version"

module Capistrano
  Configuration.instance(true).load do

    # Taken from the capistrano code.
    def _cset(name, *args, &block)
      unless exists?(name)
        set(name, *args, &block)
      end
    end

    _cset(:application, 'my_application')
    _cset(:deploy_to, "/var/lib/#{application}")

    _cset(:log_dir, '/var/log')

    _cset(:prod_conf, 'prod.conf')
    _cset(:project_home, '.')


    namespace :playframework do
      task :setup do
        run "mkdir -p #{deploy_to}"
        put "#!/bin/bash\nnohup bash -c \"cd #{deploy_to} && target/start $* &>> #{log_dir}/#{application}.log 2>&1\" &> /dev/null &", "#{deploy_to}/start.sh", :mode => '755', :via => :scp
        put "#!/bin/bash\npid=`cat RUNNING_PID 2> /dev/null`\nif [ \"$pid\" == \"\" ]; then echo '#{application} is not running'; exit 0; fi\necho 'Stopping #{application}...'\nkill -SIGTERM $pid", "#{deploy_to}/stop.sh", :mode => '755', :via => :scp
      end

      task :deploy_prod, :roles => :prod do
        package
        stop
        copy_app_files
        start_prod
      end

      task :deploy_dev, :roles => :dev do
        package
        stop
        copy_app_files
        start_dev
      end

      task :stop do
        depend :remote, deploy_to
        targets = find_servers_for_task(current_task)
        failed_targets = targets.map do |target|
          cmd = "ssh #{user}@#{target.host} 'cd #{deploy_to} && ./stop.sh'"
          target.host unless system cmd
        end.compact
        raise "Stopping #{application} failed on #{failed_targets.join(',')}" if failed_targets.any?
      end

      task :start_prod do
        targets = find_servers_for_task(current_task)
        failed_targets = targets.map do |target|
          cmd = "ssh #{user}@#{target.host} 'cd #{deploy_to} && ./start.sh -Dconfig.resource=#{prod_conf}'"
          target.host unless system cmd
        end.compact
        raise "Starting #{application} failed on #{failed_targets.join(',')}" if failed_targets.any?
      end

      task :start_dev do
        targets = find_servers_for_task(current_task)
        failed_targets = targets.map do |target|
          cmd = "ssh #{user}@#{target.host} 'cd #{deploy_to} && ./start.sh'"
          target.host unless system cmd
        end.compact
        raise "Starting #{application} failed on #{failed_targets.join(',')}" if failed_targets.any?
      end

      task :package do
        system "cd #{project_home} && play clean compile test stage"
        raise "Error in package task" if not $?.success?
      end

      task :copy_app_files do
        run  "rm -fr #{deploy_to}/target"
        upload "#{project_home}/target", deploy_to, :via => :scp, :recursive => true
      end
    end # end namespace playframework

  end if Capistrano.const_defined? :Configuration and Capistrano::Configuration.methods.map(&:to_sym).include? :instance
end # end module Capistrano
