module Deployer
  class Client
    class TTYCommand
      def self.login
        %{
          docker login #{Deployer.config.host} \
          -u #{Deployer.config.user} --password-stdin
        }
      end
      
      def self.pull(image)
        "docker pull #{image}"
      end

      def self.stop_container(name)
        %{ 
          docker stop \
          $(docker ps -a | grep \"#{name}\" | awk '{ print $1 }') || true
        }
      end
      
      def self.rm_container(name)
        %{
          docker rm  \
          $(docker ps -a | grep \"#{name}\" | awk '{ print $1 }') || true
        }
      end
  
      def self.rmi(name)
        "docker rmi -f $(docker images #{name} -q) || true"
      end

      def self.inspect(name)
        "docker inspect #{name}"
      end

      def self.docker_compose_down(path)
        "docker-compose -f #{path}/docker-compose.yml down || true"
      end

      def self.docker_compose_up(path)
        "docker-compose -f #{path} up -d"
      end

      def self.docker_compose_ps(path)
        "docker-compose -f #{path} ps"
      end

      def self.extract_compose(name)
        "docker run -i --rm #{name} cat #{Deployer.config.compose_path}"
      end
      
    end
  end
end
