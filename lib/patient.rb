require 'pry'

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

  def assign(name)
    results = DB.exec("SELECT * FROM doctors WHERE name = '#{name}';")
    doc_id = results.first['id'].to_i
    DB.exec("UPDATE patients SET doctor_id = #{doc_id} WHERE name = '#{@name}';")
    @doctor_id = doc_id
  end

  def save
    DB.exec("INSERT INTO patients (name, birthday, doctor_id) VALUES ('#{@name}', '#{@birthday}', '#{@doctor_id}')")
  end

  def edit_name(new_name)
    DB.exec("UPDATE patients SET name = '#{new_name}' WHERE name = '#{@name}';")
    @name = new_name
  end

  def edit_bday(new_bday)
    DB.exec("UPDATE patients SET birthday = '#{new_bday}' WHERE birthday = '#{@birthday}';")
    @birthday = new_bday
  end

  def delete_patient
    DB.exec("DELETE FROM patients WHERE name = '#{@name}'")
  end

  def delete_appt(name)
    result1 = DB.exec("SELECT * FROM patients WHERE name = '#{name}'")
    doctor_id = result1.first['doctor_id']
    result2 = DB.exec("DELETE FROM appointments WHERE doctor_id = #{doctor_id}")
  end

  def ==(other_patient)
    self.name == other_patient.name  && self.doctor_id == other_patient.doctor_id
  end

  def search(string)
    patient_array = []
    result = DB.exec("SELECT * FROM patients WHERE name LIKE '#{string}%'")
    result.each do |patient|
      patient_array << patient['name']
    end
    patient_array
  end
end
