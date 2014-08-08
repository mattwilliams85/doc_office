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
      add_menu
    elsif input == '3'
      exit
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
    elsif input == '5'
      main_menu
    else
      invalid
    end
  end
end

 # puts "4 > Edit patient"
 #    puts "5 > Edit doctor"
 #    puts "6 > Edit appointment"
def add_appointment
  puts "Create a new appointment"
  puts "Enter the patients name:"
  input = gets.chomp
  name = DB.exec("SELECT * FROM patients WHERE name = '#{input}';")
  if name.first.to_s != ""
    puts "that exits"
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
  doctor = Doctor.new(name,speciality,0,insurance)
  doctor.save
  puts "Dr. #{doctor.name} added!"
  sleep(0.7)
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
    puts "5 > Return to Main Menu"
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
      Doctor.find_insurance(string).each do |doctor|
        puts doctor
      end
    elsif input == '5'
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
    puts "3 > Return to Main Menu"
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

