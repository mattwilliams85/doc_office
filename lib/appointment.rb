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

  def create_appointment(name, date, cost)
    results = DB.exec("SELECT * FROM patients WHERE name = '#{name}';")
    doctor_id = results.first['doctor_id'].to_i
    patient_id = results.first['id'].to_i
    DB.exec("INSERT INTO appointments (date, cost, doctor_id, patient_id) VALUES ('#{date}', #{cost}, #{doctor_id}, #{patient_id});")
    @date = date
    @cost = cost
    @doctor = doctor_id
    @patient = patient_id

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



end

