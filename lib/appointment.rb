require 'pry'
require './lib/patient'
class Appointment

     attr_accessor :patient, :date, :cost, :doctor, :id

  def initialize(patient,date,cost,doctor,id)
    @patient = patient
    @date = date
    @cost = cost
    @doctor = doctor
    @id = id
  end

  def self.all
    appointments = []
    all_appointments = DB.exec('SELECT * FROM appointments')
    all_appointments.each do |appointment|
      patient = appointment['patient_id'].to_i
      date = appointment['date']
      cost = appointment['cost'].to_f
      doctor = appointment['doctor_id'].to_i
      id = appointment['id'].to_i
      appointments << Appointment.new(patient, date, cost, doctor, id)
    end
    appointments
  end

  def create_appointment(date, cost, doctor_id, patient_id)
    @patient = patient_id.to_i
    @doctor = doctor_id.to_i
    @date = date
    @cost = cost.to_f

    self.save
    # binding.pry
  end

  def save
    results = DB.exec("INSERT INTO appointments (date, cost, doctor_id, patient_id) VALUES ('#{@date}', #{@cost}, #{@doctor}, #{@patient}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  # def edit_name(new_name)
  #   DB.exec("UPDATE patients SET name = '#{new_name}' WHERE name = '#{@name}';")
  #   @name = new_name
  # end

  def delete
    DB.exec("DELETE FROM appointments * WHERE patient_id = '#{@patient}'")
  end

  def ==(other_appointment)
    self.patient == other_appointment.patient
  end

  def find_doctor_id(name)
     @result = nil
    Patient.all.each do |patient|
      if patient.name == name
        @result = patient.doctor_id
      else
        @result = 'whatever'
      end
    end
    @result
  end

  def find_patient_id(name)
    @result = nil
    Patient.all.each do |patient|
      if patient.name == name
        @result = patient.id
      end

    end
    @result
  end

end

