require 'spec_helper'

describe Deployer::Client::TTYDocker do 
  let(:tty_docker) { Deployer::Client::TTYDocker.new }
  let(:tty_cmd) { double('TTY::Commmand') }

  context 'happy path' do
    it 'test docker login' do
      allow(tty_cmd).to receive(:success?).and_return(true)
      allow(tty_cmd).to receive(:out).and_return('Login Succeeded')
      allow(tty_cmd).to receive(:err).and_return('')
      allow_any_instance_of(TTY::Command).to \
        receive(:run).and_return(tty_cmd)
      
      result = tty_docker.login
      expect(result.err.empty?).to be_eql(true)
      expect(result.out).to be_eql('Login Succeeded')
      expect(result.success?).to be_eql(true)
    end

    it 'docker pull image' do
      allow(tty_cmd).to receive(:success?).and_return(true)
      allow(tty_cmd).to receive(:out).and_return('Downloaded newer image for demo:1')
      allow(tty_cmd).to receive(:err).and_return('')
      
      allow_any_instance_of(TTY::Command).to receive(:run).and_return(tty_cmd)
      result = tty_docker.pull('demo:1')
      expect(result.err.empty?).to be_eql(true)
      expect(result.success?).to be_eql(true)
    end
  end

  context 'errors' do
    it 'error in command' do
      allow(tty_cmd).to receive(:success?).and_return(false)
      allow(tty_cmd).to receive(:out).and_return('')
      allow(tty_cmd).to receive(:err).and_return('Error in command')
      allow_any_instance_of(TTY::Command).to \
        receive(:run).and_return(tty_cmd)

      result = tty_docker.login
      expect(result.success?).to be_eql(false)
      expect(result.err).to be_eql('Error in command')
    end

    it 'raise an TTY::Command::ExitError' do
      allow(tty_cmd).to receive(:exit_status).and_return('no host reachable')
      allow(tty_cmd).to receive(:out).and_return('no host')
      allow(tty_cmd).to receive(:err).and_return('not allowed to login')

      tty_exit_error = TTY::Command::ExitError.new('docker login', tty_cmd)
      allow_any_instance_of(TTY::Command).to receive(:run).and_raise(tty_exit_error)
      result = tty_docker.login
      expect(result.success?).to eql(false)
      expect(result.err.include?('not allowed to login')).to eql(true)
    end
  end
end