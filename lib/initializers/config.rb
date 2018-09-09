module Deployer
  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  class Config
    attr_accessor :host
    attr_accessor :registry
    attr_accessor :user
    attr_accessor :password
    
    def initialize
      @host     = ENV['REGISTRY_HOST'] || 'host'
      @user     = ENV['REGISTRY_USER'] || 'user'
      @password = ENV['REGISTRY_PASSWORD'] || 'pass'
      @registry = @host.gsub(/http(s)*\:\/\//, '')
    end
  end
end