require './lib/insurance'
require 'pg'
require './lib/patient'
require './lib/doctor'
require './lib/appointment'

DB = PG.connect({:dbname => 'doc_office'})

def main_menu
  @sub_menu = search_doctors
  system 'clear'
  puts "==DOCTORS OFFICE=="
  puts ""
  puts "1 > Search Database"
  puts "2 > Edit Database"
  puts "3 > Exit"
  input = gets.chomp.to_s
  if input == '1'
    search_menu
  else
    invalid
  end
end

def search_menu
  @sub_menu = search_menu
  puts "1 > Search for Doctors"
  puts "2 > Search for Patients"
  input = gets.chomp.to_s
  if input == '1'
    search_doctors
  else
    invalid
  end
end

def search_doctors
  @sub_menu = search_doctors
  puts "1 > List all doctors"
  puts "2 > Search by name"
  puts "3 > Search by speciality"
  puts "4 > Search by insurance"
  input = gets.chomp.to_s
  if input == '1'
    list_doctor
  else
    invalid
  end
end

def search_patients
  @sub_menu = search_patients
  puts "1 > List all patients"
  puts "2 > Search by name"
  puts "3 > Search by birthdate"
end

def list_doctor
  Doctor.all.each do |doctor|
    puts doctor.name
  end

end

def abort
  puts ""
  puts "1 > Return to main_menu"
  puts "2 > Return to last menu"
  input = gets.chomp.to_s
  if input == '1'
    main_menu
  elsif input == '2'
    @sub_menu
  else
    invalid
    @sub_menu
  end
end

def invalid
  puts "Invalid Entry - try again"
  sleep(0.5)
  system 'clear'
  @sub_menu
end

main_menu

