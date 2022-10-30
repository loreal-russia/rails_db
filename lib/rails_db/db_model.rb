module RailsDb
  class DbModel < ActiveRecord::Base
    establish_connection(:readonly)
  end
end
