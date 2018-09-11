require 'tty-command'

module Deployer
  class Client
    class TTYDocker
      def initialize
        @tty = TTY::Command.new
      end      
      
      def login
        stripe_error do
          @tty.run(TTYCommand.login, input: "#{Deployer.config.password}")
        end
      end

      def pull(image)
        stripe_error do
          @tty.run(TTYCommand.pull(image))
        end
      end

      def inspect(name)
        stripe_error do 
          @tty.run(TTYCommand.inspect(name))
        end
      end
  
      def clean_image(name)
        @tty.run(TTYCommand.stop_container(name), only_output_on_error: true)
        @tty.run(TTYCommand.rm_container(name), only_output_on_error: true)
        @tty.run(TTYCommand.rmi(name),  only_output_on_error: true)
      end
      
      def docker_compose_down(path)
        stripe_error do 
          @tty.run(TTYCommand.docker_compose_down(path), 
            only_output_on_error: true)
        end
      end
  
      def docker_compose_up(path)
        stripe_error do 
          @tty.run(TTYCommand.docker_compose_up(path))
        end
      end
  
      def docker_compose_ps(path)
        stripe_error do 
          @tty.run(TTYCommand.docker_compose_ps(path))
        end
      end
      
      def extract_compose(name)
        stripe_error do
          @tty.run(TTYCommand.extract_compose(name))
         end
      end

      private

      def stripe_error
        yield
      rescue Errno::ENOENT => e
        Model::Base.create_error(e.to_s)
      rescue TTY::Command::ExitError => e
        Model::Base.create_error(e.to_s)
      rescue Exception => e
        Model::Base.create_error(e.to_s)
      end
    end
  end
end
