# Copyright (C) 2013 VMware, Inc.
require 'net/ssh' if Puppet.features.ssh? and ! Puppet.run_mode.master?

module PuppetX::Puppetlabs::Transport
  class Ssh
    attr_accessor :ssh
    attr_reader :name, :user, :password, :host

    def initialize(opt)
      @name     = opt[:name]
      @user     = opt[:username]
      @password = opt[:password]
      @host     = opt[:server]
      # symbolize keys for options
      options = opt[:options] || {}
      @options  = options.inject({}){|h, (k, v)| h[k.to_sym] = v; h}
      @options[:password] = @password
      default = {:timeout => 10}
      @options = default.merge(@options)
      Puppet.debug("#{self.class} initializing connection to: #{@host}")
    end

    def connect
      @ssh ||= Net::SSH.start(@host, @user, @options)
    end

    # wrapper for debugging
    def exec!(command)
      Puppet.debug("Executing on #{@host}:\n#{command}")
      result = @ssh.exec!(command)
      Puppet.debug("Execution result:\n#{result}")
      result
    end

    def exec(command)
      Puppet.debug("Executing on #{@host}:\n#{command}")
      @ssh.exec(command)
    end

    def close
      Puppet.debug("#{self.class} closing connection to: #{@host}")
      @ssh.close if @ssh
    end
  end
end
