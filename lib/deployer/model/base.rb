module Deployer
  module Model
    class Base
      
      attr_reader :out, :err

      def initialize(success, out = :empty, err = :empty)
        @success = success
        @out = out
        @err = err
      end
  
      protected

      def success?
        @success
      end
   
    end
  end
end