require 'spec_helper'

describe Appointment do
  it 'initializes with patient, date, cost, doctor and id' do
    test_appointment = Appointment.new
    expect(test_appointment).to be_an_instance_of Appointment
  end

#   it 'starts with no patients in the system' do
#     expect(Patient.all).to eq []
#   end

#   it 'lets you save patients to the database' do
#     test_patient = Patient.new('Bill', '05261956', 1)
#     test_patient.save
#     expect(Patient.all).to eq [test_patient]
#   end

#   it 'is the same patient if it has the same name' do
#     patient1 = Patient.new('John','07261985',1)
#     patient2 = Patient.new('John','07261985',1)
#     expect(patient1).to eq patient2
#   end

#   it 'edits name and birthday' do
#     patient = Patient.new('Jack', '071243', 1)
#     patient.edit_name('Jackk')
#     patient.edit_bday('1111111')
#     expect(patient.name).to eq ('Jackk')
#     expect(patient.birthday).to eq ('1111111')
#   end

#   it 'allows you to delete a patient' do
#     patient = Patient.new('joe schmoe','3241432',1)
#     patient.delete_patient
#     expect(Patient.all).to eq []
#   end
 end
