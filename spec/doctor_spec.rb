require 'spec_helper'

describe Doctor do
  it 'initializes with name, speciality and id' do
    doc = Doctor.new('Phil','Gynacology',1,2)
    expect(doc).to be_an_instance_of Doctor
  end

  it 'starts with no doctors in the system' do
    expect(Doctor.all).to eq []
  end

  it 'lets you save doctors to the system' do
    doc = Doctor.new('Rob',"Psychology",1,1)
    doc.save
    expect(Doctor.all).to eq [doc]
  end

  it 'is the same doctor if it has the same name' do
    doc1 = Doctor.new('Rob',"Psychology",1,3)
    doc2 = Doctor.new('Rob',"Psychology",1,2)
    expect(doc1).to eq doc2
  end

  it 'assigns a patient to a specified doctor' do
    doc = Doctor.new('Bill Clinton', 'Urologist', 23,2)
    patient = Patient.new('Sam','07261985',1)
    patient.assign(doc.id)
    expect(patient.doctor_id).to eq 23
  end

  it 'lists all doctors with a specified speciality' do
    doc1 = Doctor.new('Bill Clinton', 'Urologist', 23,1)
    doc2 = Doctor.new('Paul Brand', 'Urologist', 2,2)
    doc3 = Doctor.new('Foot Lovin', 'Pediatrist', 25,3)
    doc1.save
    doc2.save
    doc3.save
    Doctor.all
    expect(Doctor.find_specialists('Urologist').length).to eq 2
  end

  it 'returns the correct insurance company for a specified doctor' do
    doc1 = Doctor.new('Bill Clinton', 'Urologist', 25,2)
    doc2 = Doctor.new('George Lucas', 'Ewokologist', 23,1)
    doc1.save
    doc2.save
    expect(Doctor.find_insurance('Bill Clinton')).to eq 'Health Cross'
    expect(Doctor.find_insurance('George Lucas')).to eq 'Red Shield'
  end

  it 'deletes a specified doctor and removes his patients doctor id' do
    doc = Doctor.new('Bill Clinton', 'Urologist', 25,2)
    patient1 = Patient.new('Jon', '05261956', 1)
    patient2 = Patient.new('Sam', '05231956', 1)
    doc.save
    patient1.assign(doc.id)
    patient2.assign(doc.id)
    patient1.save
    patient2.save
    doc.delete_doctor
    expect(Doctor.all).to eq []
    expect(patient2.doctor_id).to eq 0
    expect(patient1.doctor_id).to eq 0
  end

  it 'returns all patients for a specified doctor' do
    doc = Doctor.new('Bill Clinton', 'Urologist', 28,2)
    patient1 = Patient.new('Jon', '05261956', 1)
    patient2 = Patient.new('Sam', '05231956', 1)
    patient3 = Patient.new('Pat', '05291956', 1)
    doc.save
    patient2.assign(doc.id)
    patient3.assign(doc.id)
    patient1.save
    patient2.save
    patient3.save
    expect(doc.find_patients('Bill Clinton')).to eq ['Sam', 'Pat']
  end
end
