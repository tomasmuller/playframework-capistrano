# Recipes for using PlayFramework on a server with capistrano.

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

    _cset(:prod_conf, 'prod.conf')

    # https://github.com/capistrano/capistrano/wiki/2.x-DSL-Action-Invocation-Run
    default_run_options[:shell] = '/bin/bash --login'

    # Hooks
    after "deploy", "playframework:setup", "playframework:package"

    namespace :playframework do
      task :setup do
        put "#!/bin/bash\nnohup bash -c \"cd #{current_path} && target/start $* &>> #{current_path}/log/#{application}.log 2>&1\" &> /dev/null &", "#{current_path}/start.sh", :mode => '755', :via => :scp
        put "#!/bin/bash\npid=`cat RUNNING_PID 2> /dev/null`\nif [ \"$pid\" == \"\" ]; then echo '#{application} is not running'; exit 0; fi\necho 'Stopping #{application}...'\nkill -SIGTERM $pid", "#{current_path}/stop.sh", :mode => '755', :via => :scp
        put "#!/bin/bash\nexport", "#{current_path}/envvars.sh", :mode => '755', :via => :scp
      end

      task :envvars do
        run [
          "cd #{current_path}",
          "./envvars.sh"
        ].join(" && ")
      end

      task :tests do
        run [
          "cd #{current_path}",
          "play test"
        ].join(" && ")
      end

      task :package do
        run [
          "cd #{current_path}",
          "play clean compile stage"
        ].join(" && ")
      end

      task :stop do
        run [
          "cd #{current_path}",
          "./stop.sh"
        ].join(" && ")
      end

      task :start_prod do
        run [
          "cd #{current_path}",
          "./start.sh -Dconfig.resource=#{prod_conf}"
        ].join(" && ")
      end

      task :start_dev do
        run [
          "cd #{current_path}",
          "./start.sh"
        ].join(" && ")
      end
    end

  end if Capistrano.const_defined? :Configuration and Capistrano::Configuration.methods.map(&:to_sym).include? :instance
end # end module Capistrano
