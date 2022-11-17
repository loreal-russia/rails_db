module RailsDb
  class SqlController < RailsDb::ApplicationController
    before_action :load_query, only: [:index, :execute, :csv, :xls]

    def index
    end

    def execute
      render :index
    end

    def csv
      file = Tempfile.new('results', Rails.application.paths['tmp'].expanded)
      @sql_query.write_csv(file)
      file.close
      send_file(file.path, type: 'text/csv; charset=utf-8; header=present', filename: 'results.csv')
    rescue StandardError => _e
      file.close!
    end

    def xls
      render xlsx: 'xls', filename: 'results.xlsx'
    end

    def import
    end

    def import_start
      result    = Result.ok
      if result.ok?
        flash[:notice] = 'File was successfully imported'
      else
        flash[:alert] = "Error occurred during import: #{result.error.message}"
      end
      render :import
    end

    private

    def load_query
      @sql       = "#{params[:sql]}".strip
      @sql_query = RailsDb::SqlQuery.new(@sql).execute
    end

  end
end
