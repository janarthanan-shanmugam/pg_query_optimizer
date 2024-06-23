# frozen_string_literal: true

require_relative "pg_query_optimizer/version"
require 'active_record'

module PgQueryOptimizer

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
   
    DEFAULT_SETTINGS = {
      max_parallel_workers_per_gather: 4,
      parallel_setup_cost: 1000,
      parallel_tuple_cost: 0.1,
      min_parallel_table_scan_size: '8MB',
      min_parallel_index_scan_size: '512kB'
    }.freeze

    def store_current_values
      with_suppressed_logs do
        @previous_values = {
          max_parallel_workers_per_gather: ActiveRecord::Base.connection.execute("SHOW max_parallel_workers_per_gather").first["max_parallel_workers_per_gather"],
          parallel_setup_cost: ActiveRecord::Base.connection.execute("SHOW parallel_setup_cost").first["parallel_setup_cost"],
          parallel_tuple_cost: ActiveRecord::Base.connection.execute("SHOW parallel_tuple_cost").first["parallel_tuple_cost"],
          min_parallel_table_scan_size: ActiveRecord::Base.connection.execute("SHOW min_parallel_table_scan_size").first["min_parallel_table_scan_size"],
          min_parallel_index_scan_size: ActiveRecord::Base.connection.execute("SHOW min_parallel_index_scan_size").first["min_parallel_index_scan_size"]
        }
      end
    end

    def restore_previous_values
      with_suppressed_logs do
        @previous_values.each do |key, value|
          ActiveRecord::Base.connection.execute("SET #{key} = '#{value}'")
        end
      end
    end

    def sufficient_resources?
      # Implement checks to ensure system has sufficient resources
      total_memory = `free -m | grep Mem: | awk '{print $2}'`.to_i
      required_memory = 1024 # required memory in MB

      total_memory >= required_memory
    end

    def enable_parallel_execution
      store_current_values
      with_suppressed_logs do
        DEFAULT_SETTINGS.each do |key, value|
          ActiveRecord::Base.connection.execute("SET #{key} = '#{value}'")
        end
      end
    end

    def reset_parallel_execution
      restore_previous_values
    end

    def pg_optimize(max_workers: 4)
      verify_postgresql_adapter!
      if sufficient_resources?
        enable_parallel_execution
        yield
      else
        # If resources are insufficient, run the query without parallel execution
        yield
      end
    ensure
      reset_parallel_execution 
    end

    def verify_postgresql_adapter!
      unless ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql'
        raise UnsupportedDatabaseError, "PgQueryOptimizer only supports PostgreSQL"
      end
    end

    def with_suppressed_logs
      original_logger = ActiveRecord::Base.logger
      begin
        ActiveRecord::Base.logger = Logger.new(nil)  # Suppress logs
        yield
      ensure
        ActiveRecord::Base.logger = original_logger  # Restore original logger
      end
    end
  end
end

ActiveRecord::Base.include(PgQueryOptimizer)
