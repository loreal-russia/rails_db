module RailsDb
  module Adapters

    class BaseAdapter
      extend ::RailsDb::Connection

      MULTI_STATEMENT_HELP_TEXT = "EXPERIMENTAL: You can import only file with SQL statements separated by ';'. Each new statement must start from new line."

      def self.execute_with_rollback
        connection.transaction do
          yield
          raise ActiveRecord::Rollback
        end
      end

      def self.execute(sql)
        t0 = Time.now
        execute_with_rollback do
          connection.execute(sql)
        end
        Time.now - t0
      end

      def self.exec_query(sql)
        t0 = Time.now
        results = nil

        execute_with_rollback do
          results = connection.exec_query(sql)
        end

        execution_time = Time.now - t0
        [results, execution_time]
      end

      def self.select(sql)
        BaseAdapter.exec_query(sql)
      end

      def self.explain(sql)
        BaseAdapter.exec_query(sql)
      end

      def self.adapter_name
        'base'
      end

      def self.mime
        'text/x-sql'
      end

      def self.truncate; end

      def self.delete; end

      def self.count(table_name)
        select("SELECT COUNT(*) FROM #{table_name}")[0].rows.flatten.last.to_i
      end

      def self.primary_key(table_name)
        connection.primary_key(table_name)
      end

      def self.indexes(table_name)
        connection.indexes(table_name)
      end

      private

      def self.multiple_execute(sql, divider = ";\n")
        sql.split(divider).each do |statement|
          execute_with_rollback do
            connection.execute(statement)
          end
        end
      end
    end
  end
end
