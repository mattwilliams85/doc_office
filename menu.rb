require './lib/insurance'
require 'pg'
require './lib/patient'
require './lib/doctor'
require './lib/appointment'
require 'pry'

DB = PG.connect({:dbname => 'doc_office'})

def main_menu
  loop do
    header
    puts "1 > Search Database"
    puts "2 > Edit Database"
    puts "3 > Exit"
    input = gets.chomp
    if input == '1'
      search_menu
    elsif input == '2'
      sub_menu
    elsif input == '3'
      exit
    else
      invalid
    end
  end
end

def sub_menu
  loop do
    header
    puts "1 > Add patient/ doctor/ appointment"
    puts "2 > Update patient/ doctor"
    puts "3 > Delete patient/ doctor/ appointment"
    puts "4 > Main Menu"
    input = gets.chomp
    if input == '1'
      add_menu
    elsif input == '2'
      edit_menu
    elsif input == '3'
      delete_menu
    elsif input == '4'
      main_menu
    else
      invalid
    end
  end
end

def add_menu
  loop do
    header
    puts "1 > Add new patient"
    puts "2 > Add new doctor"
    puts "3 > Add new appointment"
    puts "4 > Assign patient to doctor"
    puts "5 > Return to Main Menu"
    input = gets.chomp
    if input == '1'
      add_patient
    elsif input == '2'
      add_doctor
    elsif input == '3'
      add_appointment
    elsif input == '4'
      assign_patient
    elsif input == '5'
      main_menu
    else
      invalid
    end
  end
end

def delete_menu
  loop do
    header
    puts "1 > Delete a patient"
    puts "2 > Delete a doctor"
    puts "3 > Delete an appointment"
    puts "4 > Main Menu"
    input = gets.chomp
    if input == '1'
      delete_patient
    elsif input == '2'
      delete_doctor
    elsif input == '3'
      delete_appointment
    elsif input == '4'
      main_menu
    else
      invalid
      delete_menu
    end
  end
end

def edit_menu
  loop do
    header
    puts "1 > Edit patient"
    puts "2 > Edit doctor"
    puts "3 > Main Menu"
    input = gets.chomp
    if input == '1'
      edit_patient
    elsif input == '2'
      edit_doctor
    elsif input == '3'
      main_menu
    else
      invalid
      edit_menu
    end
  end
end

def edit_patient
  puts "Enter patient's name you wish to update:"
  input = gets.chomp
  Patient.all.each do |patient|
    if patient.name == input
      puts "Enter new name:"
      new_name = gets.chomp
      puts "Enter new birthdate (YYYY-MM-DD)"
      new_date = gets.chomp
      patient.edit_name(new_name)
      patient.edit_bday(new_date)
      puts "#{input} has been updated!"
      sleep(0.7)
    end
  end
end

def edit_doctor
  puts "Enter doctor's name you wish to update:"
  input = gets.chomp
  Doctor.all.each do |doctor|
    if doctor.name == input
      puts "Enter new name:"
      new_name = gets.chomp
      puts "Enter new speciality"
      new_speciality = gets.chomp
      puts "Enter new insurance ID #"
      new_insurance = gets.chomp
      doctor.edit_name(new_name)
      doctor.edit_insurance(new_insurance)
      doctor.edit_speciality(new_speciality)
      puts "#{input} has been updated!"
      sleep(0.7)
    end
  end
end

def delete_patient
  puts "Enter the patient's name"
  patient_name = gets.chomp
  Patient.all.each do |patient|
    if patient.name == patient_name
      patient.delete_patient
      puts "#{patient_name} has been deleted!"
      sleep(0.7)
    end
  end
end

def delete_doctor
  puts "Enter the doctor's name"
  doctor_name = gets.chomp
  Doctor.all.each do |doctor|
    if doctor.name == doctor_name
      doctor.delete_doctor
      puts "#{doctor_name} has been deleted!"
      sleep(0.7)
    end
  end
end

def delete_appointment
  puts "Enter the name of the patient who's appointment you'd like to delete"
  patient_name = gets.chomp
  Appointment.all.each do |appointment|
    if appointment.patient == appointment.find_patient_id(patient_name)
      appointment.delete
      puts "#{patient_name}'s appointment has been deleted!"
      sleep(0.7)
    end
  end
end

def assign_patient
  puts "Enter the doctor's name"
  doctor_name = gets.chomp
  puts "Enter the patient's name"
  patient_name = gets.chomp
  Patient.all.each do |patient|
    if patient.name == patient_name
      patient.assign(doctor_name)
      puts "#{patient_name} has been assigned to Dr. #{doctor_name}!"
      sleep(0.7)
    end
  end
end
    # puts "4 > Edit patient"
    # puts "5 > Edit doctor"
    # puts "6 > Edit appointment"

def add_appointment
  puts "Create a new appointment"
  puts "Enter the patient's name:"
  @name_input = gets.chomp
  name = DB.exec("SELECT * FROM patients WHERE name = '#{@name_input}';")
  doctor_id = name.first['doctor_id'].to_i
  # binding.pry
  if name.first.to_s != ""
    puts "Enter appointment date (YYYY-MM-DD):"
    date = gets.chomp
    if date.count('-') == 2 || date.length == 10
      puts "Enter the cost of this appointment i.e.(0.00):"
      cost = gets.chomp
      if cost.to_i > 0 && cost.to_s.count('.') == 1
        app = Appointment.new(0,'',0.00,0,0)
        var = app.find_doctor_id(@name_input)
        # binding.pry
        app.create_appointment(date,cost, var ,app.find_patient_id(@name_input))
        puts "Your appointment for #{@name_input} on #{date} for $#{cost} has been created!"
        sleep(1)
        add_menu
      else
        invalid
      end
    else
      invalid
    end
  else
    invalid
  end
end


def add_patient
  puts "Create a new patient"
  puts "Enter patients name:"
  name = gets.chomp
  puts "Enter birthday (YYYY-MM-DD):"
  bday = gets.chomp
  if bday.count('-') != 2 || bday.length != 10
    invalid
  else
  patient = Patient.new(name,bday,0)
  patient.save
  puts "Patient #{patient.name} added!"
  sleep(0.7)
  end
end

def add_doctor
  puts "Create a new doctor"
  puts "Enter doctors name:"
  name = gets.chomp
  puts "Enter speciality:"
  speciality = gets.chomp
  puts "Enter insurance number:"
  Insurance.all.each_with_index do |company, index|
    puts (index + 1).to_s + ' ' + company.name
  end
  insurance = gets.chomp.to_i
  if insurance < 4 && insurance > 0
  doctor = Doctor.new(name,speciality,0,insurance)
  doctor.save
  puts "Dr. #{doctor.name} added!"
  sleep(0.7)
  else
  invalid
  add_menu
end
end

def search_menu
  loop do
    header
    puts "1 > Search for Doctors"
    puts "2 > Search for Patients"
    puts "3 > Return to Main Menu"
    input = gets.chomp.to_s
    if input == '1'
      search_doctors
    elsif input == '2'
      search_patients
    elsif input == '3'
      main_menu
    else
      invalid
    end
  end
end

def search_doctors
  loop do
    header
    puts "1 > List all doctors"
    puts "2 > Search by name"
    puts "3 > Search by speciality"
    puts "4 > Search by insurance"
    puts "5 > See all doctor's patients"
    puts "6 > Return to Main Menu"
    input = gets.chomp.to_s

    if input == '1'
      Doctor.all.each do |doctor|
        puts doctor.display_info
      end
    elsif input == '2'
      puts "Type search name here:"
      string = gets.chomp
      puts Doctor.search(string)
    elsif input == '3'
      puts "Type the speciality you are looking for:"
      string = gets.chomp
      Doctor.all
      Doctor.find_specialists(string).each do |doctor|
        puts 'Dr.' + doctor
      end
    elsif input == '4'
      puts "Type insurance to see doctor affiliation:"
      puts '[SELECT]'
      Insurance.all.each do |company|
        puts company.name
      end
      string = gets.chomp
      Insurance.all.each do |company|
        if string != company
          invalid
          search_doctors
        end
      end
      Doctor.find_insurance(string).each do |doctor|
        puts doctor
      end
    elsif input == '5'
      puts "Type name of doctor to see his patients:"
      input = gets.chomp
      Doctor.find_patients(input).each do |patient|
        puts patient
      end
    elsif input == '6'
      main_menu
    else
      invalid
      search_doctors
    end
    puts ""
    puts "Press Enter to continue"
    gets.chomp
  end

end

def search_patients
  loop do
    header
    puts "1 > List all patients"
    puts "2 > Search by name"
    puts "3 > Show all patient's appointments"
    puts "4 > Return to Main Menu"
    input = gets.chomp
    if input == '1'
      Patient.all.each do |patient|
        puts patient.display_info
      end
    elsif input == '2'
      puts "Type search name here:"
      string = gets.chomp
      Patient.search(string).each do |patient|
        puts patient
      end
    elsif input == '3'
      show_app
    elsif input == '4'
      main_menu
    else
      invalid
      search_doctors
    end
    puts ""
    puts "Press Enter to continue"
    gets.chomp
  end
end

  def show_app
    puts "Type in name of patient:"
    input = gets.chomp
    Patient.all.each do |patient|
      if patient.name == input
        @id = patient.doctor_id
      end
    end
    # binding.pry
    Appointment.all.each do |appointment|
      if appointment.patient == @id
        puts appointment.date + ' | $' + appointment.cost.to_s
      end
    end
  end


def invalid
  puts "Invalid Entry - try again"
  sleep(0.5)
  system 'clear'
end

def header
  system 'clear'
  puts " ===DOCTORS OFFICE==="
  puts ''
end

main_menu

