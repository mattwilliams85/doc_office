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

  def create_var
    @doc1 = Doctor.new('Phil','Gynacology',10,2)
    @doc2 = Doctor.new('Rob',"Urologist",11,1)
    @doc3 = Doctor.new('Bill Clinton', 'Urologist', 23,2)
    @pat1 = Patient.new('Sam','07261985',1)
    @pat2 = Patient.new('Kate','54382943',2)
    @pat3 = Patient.new('Champ','3242423',3)
  end

  def save_var
    @doc1.save
    @doc2.save
    @doc3.save
    @pat1.save
    @pat2.save
    @pat3.save
  end
end
