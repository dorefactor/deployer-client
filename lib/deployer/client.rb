require_relative 'client/registry'
require_relative 'client/tty_command'
require_relative 'client/tty_docker'


module Deployer
  class Client

## vars registry
##
## path
##
##
##
##
    def images
      # registry._catalog_v2
    end

    def tags(image)
      # registry.tags
    end

    def pull(fullname)
      ## Start the process
      ## Provision
        ## workspace
        ## pull image
        ## extract_compose
        ## inspect
        ## modify compose
        ## docker-compose down
        ## docker-compose up
        ## docker-compose ps
    end

  end
end