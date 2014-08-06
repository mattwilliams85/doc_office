require './lib/doctor.rb'

class Patient
  attr_accessor :name, :birthday, :doctor_id

  def initialize(name, birthday, doctor_id)
    @name = name
    @birthday = birthday
    @doctor_id = doctor_id
  end

  def self.all
    patients = []
    all_patients = DB.exec('SELECT * FROM patients')
    all_patients.each do |patient|
      name = patient['name']
      birthday = patient['birthday']
      doctor_id = patient['doctor_id'].to_i
      patients << Patient.new(name, birthday, doctor_id)
    end
    patients
  end



    # patient_array = []
    # self.each do |patient|
    #   if patient.doctor_id == doc_id
    #     patient_array << patient.name
    #   end
    # end
    # patient_array
  # end

  def assign(id)
    self.doctor_id = id
  end

  def save
    DB.exec("INSERT INTO patients (name, birthday, doctor_id) VALUES ('#{@name}', '#{@birthday}', '#{@doctor_id}')")
  end

  def update
  end

  def delete_patient
    DB.exec("DELETE FROM patients WHERE name = '#{@name}'")
  end

  def ==(other_patient)
    self.name == other_patient.name  && self.doctor_id == other_patient.doctor_id
  end

end
