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

  it 'edits name and birthday' do
    patient = Patient.new('Jack', '071243', 1)
    patient.edit_name('Jackk')
    patient.edit_bday('1111111')
    expect(patient.name).to eq ('Jackk')
    expect(patient.birthday).to eq ('1111111')
  end

  it 'allows you to delete a patient' do
    patient = Patient.new('joe schmoe','3241432',1)
    patient.delete_patient
    expect(Patient.all).to eq []
  end

  it 'allows you to search for like names' do
    pat1 = Patient.new('Mark','3241432',1)
    pat2 = Patient.new('Matthew','3241432',2)
    pat3 = Patient.new('McShmitties','3241432',3)
    pat1.save
    pat2.save
    pat3.save
    expect(pat1.search('Ma')).to eq ['Mark','Matthew']
  end
end
