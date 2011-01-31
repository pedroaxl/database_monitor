#!/usr/bin/env ruby
# coding: utf-8

require 'rubygems'
require 'bundler/setup'

require 'optparse'
require 'ostruct'
require 'yaml'

require File.dirname(__FILE__) + '/monitor'

module DatabaseMonitor
  class Daemon
    attr_reader :options

    def initialize(arguments, stdin)
      @arguments = arguments
      @stdin = stdin

      # Set default options
      @options = OpenStruct.new
      @options.config_file = 'config.yml'
      @options.verbose = false
      @options.log_file = 'monitor.log'
      @options.pid_file = 'monitor.pid'

      @config = nil
      @pid_file = nil
      @log = nil
    end

    def run
      parse_options
      set_logger
      read_config
      be_verbose if @options.verbose

      # if -f is not present we fork into the background and write monitor.pid
      daemonize
      @log.close  
    end


    protected
    def exit_gracefully
      remove_pid
      @log.info "Terminating database monitor..." 
      @log.close unless @log.nil? rescue nil
      exit 0
    end

    def remove_pid
      if !@pid_file.nil? and File.exist? @pid_file
        @log.info "Removing pid file #{@pid_file}..." 
        File.unlink @pid_file
      end
    end


    def read_config    
      begin
        @config = YAML.load(File.open(@options.config_file,'r').read)
      rescue Exception => e      
        @log.fatal "Error reading config file #{@options.config_file}: #{e.inspect}"
        exit -1
      end
    end

    def set_logger
      require 'logger'
      @log = Logger.new(@options.log_file, 'daily')
      @log.level = Logger::INFO
    end

    def daemonize
      begin
        @pid_file = @options.pid_file 
        pid = fork do
          start_monitor
        end
        File.open(@pid_file, 'w+'){|f| f.write pid.to_s }
        Process.detach(pid)
      rescue Exception => e
        @log.fatal "Error while daemonizing: #{e.inspect}"
        exit
      end
    end

    def parse_options
      opts = OptionParser.new 
      opts.on('-v', '--version')            { puts "Database Monitor version #{VERSION}" ; exit 0 }
      opts.on('-h', '--help')               { puts opts; exit 0  }
      opts.on('-V', '--verbose')            { @options.verbose = true }  
      opts.on('-l', '--log log_file')       { |log_file| @options.log_file = log_file }
      opts.on('-p', '--pid pid_file')       { |pid_file| @options.pid_file = pid_file }
      opts.on('-c', '--conf config_file')   { |conf| @options.config_file = conf }
      opts.parse!(@arguments)
    end

    def be_verbose
      @log.info "Start at #{DateTime.now}"
      @log.info "Options:\n"
      @options.marshal_dump.each do |name, val|        
        @log.info "  #{name} = #{val}"
      end
      @log.level = Logger::DEBUG
    end
    
    def start_monitor
      Monitor.new(@config, @log).run
    end
  end
end