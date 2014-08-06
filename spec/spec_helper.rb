require 'rspec'
require 'pg'
require 'doctor'
require 'patient'

DB = PG.connect(:dbname => 'doc_office_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE from doctors *;")
    DB.exec("DELETE from patients *;")
  end
end
