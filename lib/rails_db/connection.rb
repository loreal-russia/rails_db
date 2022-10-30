module RailsDb
  module Connection

    def connection
      unless defined?(ReadOnlyConnection)
        Object.const_set('ReadOnlyConnection', Class.new(ActiveRecord::Base) do
          self.abstract_class = true
          def self.name
            'RailsDb::Connection::ReadOnlyConnection'
          end
          establish_connection(:readonly)
        end)
      end

      ReadOnlyConnection.connection
    end

    def columns
      connection.columns(name)
    end

    def column_properties
      %w(name sql_type null limit precision scale type default)
    end

    def to_param
      name
    end

    def column_names
      columns.collect(&:name)
    end
  end
end
