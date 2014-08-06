require 'spec_helper'

describe Patient do
  it 'initializes with name, speciality and id' do
    test_patient = Patient.new('Phil','04151988',1)
    expect(test_patient).to be_an_instance_of Patient
  end

  it 'starts with no patients in the system' do
    expect(Patient.all).to eq []
  end

  it 'lets you save patients to the database' do
    test_patient = Patient.new('Bill', '05261956', 1)
    test_patient.save
    expect(Patient.all).to eq [test_patient]
  end

  it 'is the same patient if it has the same name' do
    patient1 = Patient.new('John','07261985',1)
    patient2 = Patient.new('John','07261985',1)
    expect(patient1).to eq patient2
  end

  it 'allows you to delete a patient' do
    patient = Patient.new('joe schmoe','3241432',1)
    patient.delete_patient
    expect(Patient.all).to eq []
  end
end
