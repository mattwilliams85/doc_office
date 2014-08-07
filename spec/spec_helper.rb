require 'rspec'
require 'pg'
require 'doctor'
require 'patient'
require 'appointment'
require 'pry'

DB = PG.connect(:dbname => 'doc_office_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctors *;")
    DB.exec("DELETE FROM patients *;")
    DB.exec("DELETE FROM appointments *;")
  end
end
