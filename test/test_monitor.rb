require 'helper'
require 'monitor'

class DatabaseMonitor::Monitor
  @@counter = []
  def self.notify(match, result, old_result)
    body = %{
Hello,
I need to notify you that we had a problem with your database queries.
Your queries were #{match} in an interval of 60 seconds.

ACTUAL QUERY
  #{result.inspect}
        
OLD QUERY
  #{old_result.inspect}         
      }
    @@counter << body
  end
  def self.counter
    @@counter
  end
end

class TestMonitor < Test::Unit::TestCase

  def setup
    create_database
    populate_database
    @m = DatabaseMonitor::Monitor.new(config)
  end
  
  def test_empty?
    old_value = @db[config["queries"]["queue_deliveries"]["sql"]].all
    @db[:queue_deliveries].delete
    new_value = @db[config["queries"]["queue_deliveries"]["sql"]].all
    assert !DatabaseMonitor::Monitor.empty?(old_value)
    assert DatabaseMonitor::Monitor.empty?(new_value)
  end
  
  def test_equal?
    old_value = @db[config["queries"]["queue_deliveries"]["sql"]].all
    @db[:queue_deliveries].filter(:message_id => 1).delete
    new_value = @db[config["queries"]["queue_deliveries"]["sql"]].all
    assert DatabaseMonitor::Monitor.equal?(old_value,old_value)
    assert !DatabaseMonitor::Monitor.equal?(old_value,new_value)
  end
  
  def test_different?
    old_value = @db[config["queries"]["queue_deliveries"]["sql"]].all
    populate_database
    new_value = @db[config["queries"]["queue_deliveries"]["sql"]].all

    assert !DatabaseMonitor::Monitor.different?(old_value,old_value)
    assert DatabaseMonitor::Monitor.different?(old_value,new_value)
    assert_equal :different, DatabaseMonitor::Monitor.compare(old_value, new_value)
  end

  def test_compare_equal_values
    old_value = @db[config["queries"]["queue_deliveries"]["sql"]].all
    
    d = DatabaseMonitor::Monitor.new(config)
    
    v = DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v, DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v+1, DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v+1, DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v+1, DatabaseMonitor::Monitor.counter.size
    
    config_f = config
    config_f["queries"]["queue_deliveries"]["notifications"]["equal"] = false
    d = DatabaseMonitor::Monitor.new(config_f)
    v = DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v, DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v, DatabaseMonitor::Monitor.counter.size
  end
  
  def test_compare_different_values    
   d = DatabaseMonitor::Monitor.new(config)
   v = DatabaseMonitor::Monitor.counter.size
   d.compare_queries("queue_deliveries")
   assert_equal v, DatabaseMonitor::Monitor.counter.size
   populate_database
   d.compare_queries("queue_deliveries")
   assert_equal v, DatabaseMonitor::Monitor.counter.size
    
   config_f = config
   config_f["queries"]["queue_deliveries"]["notifications"]["different"] = true
   
   d = DatabaseMonitor::Monitor.new(config_f)
   v = DatabaseMonitor::Monitor.counter.size
   d.compare_queries("queue_deliveries")
   assert_equal v, DatabaseMonitor::Monitor.counter.size
   populate_database
   d.compare_queries("queue_deliveries")
   assert_equal v+1, DatabaseMonitor::Monitor.counter.size
   populate_database
   d.compare_queries("queue_deliveries")
   assert_equal v+1, DatabaseMonitor::Monitor.counter.size
  end

  def test_compare_partial_match_values
    d = DatabaseMonitor::Monitor.new(config)
    v = DatabaseMonitor::Monitor.counter.size
    d.compare_queries("queue_deliveries")
    assert_equal v, DatabaseMonitor::Monitor.counter.size
    10.times{ @db[:queue_deliveries].insert(:message_id => 1) }
    d.compare_queries("queue_deliveries")
    assert_equal v+1, DatabaseMonitor::Monitor.counter.size
  end  
  
  
  
  def teardown
    File.delete('testdatabase.db')
  end
  
  def create_database
    @db = Sequel.connect(config['database']['connection_string'])
    @db.create_table :queue_deliveries do
      primary_key :id
      Integer :message_id
    end
  end
  
  def populate_database
    10.times{ @db[:queue_deliveries].insert(:message_id => 1) }
    20.times{ @db[:queue_deliveries].insert(:message_id => 2) }
    30.times{ @db[:queue_deliveries].insert(:message_id => 3) }
  end
  
  def config
    {
        "database" => {
            "connection_string" => "sqlite://testdatabase.db"
        },
           "email" => {
            "username" => "john",
            "password" => 1234
        },
         "options" => {
            "timeout" => 60
        },
         "queries" => {
            "queue_deliveries" => {
                          "sql" => "SELECT message_id, count(*) from queue_deliveries GROUP BY message_id",
                "notifications" => {
                            "empty" => false,
                            "equal" => true,
                        "different" => false,
                    "partial_match" => true
                }
            }
        }
    }
  end

end
