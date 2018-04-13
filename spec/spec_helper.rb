require 'elasticsearch/extensions/test/cluster'
require 'yaml'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Start an in-memory cluster for Elasticsearch as needed
  es_config = YAML.load_file("config/elasticsearch.yml")["test"]
  ES_BIN = es_config["es_bin"]
  ES_PORT = es_config["port"]
  config.before :all, elasticsearch: true do
    Elasticsearch::Extensions::Test::Cluster.start(command: ES_BIN, port: ES_PORT.to_i, nodes: 1, timeout: 120)  unless Elasticsearch::Extensions::Test::Cluster.running?(command: ES_BIN, on: ES_PORT.to_i)
  end
  # Stop elasticsearch cluster after test run
  config.after :suite do
    #Elasticsearch::Extensions::Test::Cluster.stop(command: ES_BIN, port: ES_PORT.to_i, nodes: 1) if Elasticsearch::Extensions::Test::Cluster.running?(command: ES_BIN, on: ES_PORT.to_i)
  end
  # Create indexes for all elastic searchable models
  config.before :each, elasticsearch: true do
    ActiveRecord::Base.descendants.each do |model|
      if model.respond_to?(:__elasticsearch__)
        begin
          model.__elasticsearch__.create_index!
          model.__elasticsearch__.refresh_index!
        rescue => Elasticsearch::Transport::Transport::Errors::NotFound
          # This kills "Index does not exist" errors being written to console
        rescue => e
          STDERR.puts "There was an error creating the elasticsearch index for #{model.name}: #{e.inspect}"
        end
      end
    end
  end
  # Delete indexes for all elastic searchable models to ensure clean state between tests
  config.after :each, elasticsearch: true do
    ActiveRecord::Base.descendants.each do |model|
      if model.respond_to?(:__elasticsearch__)
        begin
          model.__elasticsearch__.delete_index!
        rescue => Elasticsearch::Transport::Transport::Errors::NotFound
          # This kills "Index does not exist" errors being written to console
        rescue => e
          STDERR.puts "There was an error removing the elasticsearch index for #{model.name}: #{e.inspect}"
        end
      end
    end
  end
end
