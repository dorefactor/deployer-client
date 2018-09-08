module Deployer
  module Model
    class Base
      
      attr_reader :out, :err

      def self.create_error(err)
        Deployer::Model::Base.new(false, :empty, err)
      end

      def self.create_success(out)
        Deployer::Model::Base.new(true, out, :empty)
      end

      def initialize(success, out = :empty, err = :empty)
        @success = success
        @out = out
        @err = err
      end

      def success?
        @success
      end
   
    end
  end
end