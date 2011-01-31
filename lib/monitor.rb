module DatabaseMonitor
  class Monitor
    require 'sequel'
    require 'set'
    require 'pony'

    def initialize(config)
      @config = config
      @db = Sequel.connect(@config['database']['connection_string'])
      @last_queries = {}
      @last_match = {}
    end
    
    def run
      loop do
        for name, query in @config["queries"]
          compare_queries(name)
        end
        sleep(@config["options"]["timeout"])
      end
    end
    
    def compare_queries(name)
      result = @db[@config["queries"][name]["sql"]].all
      if @last_queries[name]
        match = Monitor.compare(result, @last_queries[name]) 
        Monitor.notify(match, result, @last_queries[name]) if @config["queries"][name]["notifications"][match.to_s] and (match != @last_match[name])
      end
      @last_queries[name] = result
      @last_match[name] = match if match
    end
  
    def self.compare(result, old_result)
      return :empty if empty?(result)
      return :equal if equal?(result, old_result)
      return :different if different?(result, old_result)
      return :partial_match
    end
    
    def self.empty?(result)
      result.empty?
    end
    
    def self.equal?(result, old_result)
      Set.new(result) == Set.new(old_result)
    end
    
    def self.different?(result, old_result)
      Set.new(result).intersection(old_result).empty? 
    end
    
    def self.notify(match, result, old_result)
      body = %{
Hello,
I need to notify you that we had a problem with your database queries.
Your queries were #{match} in an interval of #{@config[options][timeout]} seconds.

ACTUAL QUERY
  #{result.inspect}
        
OLD QUERY
  #{old_result.inspect}         
      }

      Pony.mail(
      :to => @config["email"]["to_address"],
      :from => @config["email"]["from_address"],
      :subject => @config["email"]["subject"],
      :body => body,
      :via => :smtp, :via_options => {
        :address              => 'smtp.gmail.com',
        :port                 => '587',
        :enable_starttls_auto => true,
        :user_name            => @config["email"]["username"],
        :password             => @config["email"]["password"],
        :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
      })
    end
  end
end