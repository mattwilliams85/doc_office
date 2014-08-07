require './lib/patient'
require './spec/spec_helper'

class Doctor
  attr_accessor :name, :speciality, :id, :insurance_id

  def initialize(name, speciality, id=nil, insurance_id)
    @name = name
    @speciality = speciality
    @id = id
    @insurance_id = insurance_id
  end

  def self.all
    @doctors = []
    all_doctors = DB.exec('SELECT * FROM doctors')
    all_doctors.each do |doctor|
      name = doctor['name']
      speciality = doctor['speciality']
      insurance_id = doctor['insurance_id'].to_i
      @doctors << Doctor.new(name, speciality, insurance_id)
    end
    @doctors
  end

  def edit_name(new_name)
    DB.exec("UPDATE doctors SET name = '#{new_name}' WHERE name = '#{@name}';")
    @name = new_name
  end

  def edit_insurance(new_insurance)
    new_insurance = new_insurance.to_i
    DB.exec("UPDATE doctors SET insurance_id = '#{new_insurance}' WHERE insurance_id = '#{@insurance_id}';")
    @insurance_id = new_insurance
  end

  def edit_speciality(new_speciality)
    DB.exec("UPDATE doctors SET speciality = '#{new_speciality}' WHERE speciality = '#{@speciality}';")
    @speciality = new_speciality
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, speciality, insurance_id) VALUES ('#{@name}', '#{@speciality}', '#{@insurance_id}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(other_doctor)
    self.name == other_doctor.name
  end

  def self.find_specialists(speciality)
    doc_array = []
    @doctors.each do |doc|
      if doc.speciality == speciality
        doc_array << doc.name
      end
    end
    doc_array
  end

   def find_patients(doc_name)
    patient_array = []
    result = DB.exec("SELECT * FROM doctors WHERE name = '#{doc_name}'")
    doc_id = result.first['id'].to_i

    result = DB.exec("SELECT * FROM patients WHERE doctor_id = #{doc_id}")
    result.each do |patient|
      patient_array << patient['name']
    end
    patient_array
  end

  def self.find_insurance(doc_name)
    result = DB.exec("SELECT * FROM doctors WHERE name = '#{doc_name}'")
    insurance = result.first['insurance_id'].to_i
    result2 = DB.exec("SELECT * FROM insurance_companies WHERE id = #{insurance}")
    insurance = result2.first['name']
  end

  def delete_speciality
    DB.exec("UPDATE doctors SET speciality='none' WHERE name = '#{@name}';")
  end

  def delete_doctor
    result = DB.exec("SELECT * FROM doctors WHERE name = '#{@name}'")
    doc_id = result.first['id'].to_i
    DB.exec("UPDATE patients SET doctor_id = 0 WHERE doctor_id = #{doc_id};")
    DB.exec("DELETE FROM doctors WHERE name = '#{@name}'")
  end

  def find_sum(range1,range2)
    sum = DB.exec("SELECT sum(cost) FROM appointments WHERE doctor_id = #{@id} AND date >= '#{range1}' AND date <= '#{range2}'")
    sum.first['sum'].to_f
  end
end
