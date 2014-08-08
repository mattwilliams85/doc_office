require 'spec_helper'

describe Doctor do

def create_var
  @doc1 = Doctor.new('Phil','Gynacology',10,2)
  @doc2 = Doctor.new('Rob',"Urologist",11,1)
  @doc3 = Doctor.new('Bill Clinton', 'Urologist', 23,2)
  @pat1 = Patient.new('Sam','07261985',1)
  @pat2 = Patient.new('Kate','54382943',2)
  @pat3 = Patient.new('Champ','3242423',3)
end

def save_var
  @doc1.save
  @doc2.save
  @doc3.save
  @pat1.save
  @pat2.save
  @pat3.save
end

  it 'initializes with name, speciality and id' do
    create_var
    expect(@doc1).to be_an_instance_of Doctor
  end

  it 'starts with no doctors in the system' do
    expect(Doctor.all).to eq []
  end

  it 'lets you save doctors to the system' do
    create_var
    save_var
    expect(Doctor.all).to eq [@doc1,@doc2,@doc3]
  end

  it 'adds up all the money a doctor has made for date range' do
    app1 = Appointment.new(0,'',0.00,0,0)
    app2 = Appointment.new(0,'',0.00,0,0)
    create_var
    save_var
    @pat1.assign('Phil')
    @pat2.assign('Phil')
    app1.create_appointment('Sam','1985-07-26','10.00')
    app2.create_appointment('Kate','1985-08-02','20.00')
    expect(@doc1.find_sum('1985-01-01','1985-12-31')).to eq 30.00
  end

  it 'is the same doctor if it has the same name' do
    doc1 = Doctor.new('Rob',"Psychology",1,3)
    doc2 = Doctor.new('Rob',"Psychology",1,2)
    expect(@doc1).to eq @doc2
  end

  it 'edits name, speciality, and insurance' do
    create_var
    @doc1.edit_name('Jackk')
    @doc1.edit_speciality('geriatics')
    @doc1.edit_insurance('3')
    expect(@doc1.name).to eq ('Jackk')
    expect(@doc1.speciality).to eq ('geriatics')
    expect(@doc1.insurance_id).to eq (3)
  end

  it 'assigns a patient to a specified doctor' do
    create_var
    save_var
    @pat1.assign('Phil')
    @pat1.save
    expect(@pat1.doctor_id).to eq @doc1.id
  end

  it 'lists all doctors with a specified speciality' do
    create_var
    save_var
    Doctor.all
    expect(Doctor.find_specialists('Urologist').length).to eq 2
  end

  it 'returns the correct doctors for a specified insurance company' do
    doc1 = Doctor.new('Bill', 'Urologist', 25,2)
    doc2 = Doctor.new('George', 'Ewokologist', 23,1)
    doc1.save
    doc2.save
    expect(Doctor.find_insurance('Red Shield')).to eq ['George | Ewokologist']
  end

  it "deletes a specified doctor and removes his patients' doctor id" do
    create_var
    save_var
    @pat1.assign(@doc1.name)
    @pat2.assign(@doc1.name)
    @doc1.delete_doctor
    expect(Doctor.all).to eq [@doc2,@doc3]
    expect(@pat2.doctor_id).to eq @doc1.id
    expect(@pat1.doctor_id).to eq @doc1.id
  end

  it 'returns all patients for a specified doctor' do
    create_var
    save_var
    @pat2.assign(@doc3.name)
    @pat3.assign(@doc3.name)
    expect(@doc3.find_patients('Bill Clinton')).to eq ['Kate','Champ']
  end

    it 'allows you to search for like names' do
    doc1 = Doctor.new('Mark','Stuff',1,1)
    doc2 = Doctor.new('Matthew','Whatever',2,2)
    doc3 = Doctor.new('McShmitties','IDK',3,3)
    doc1.save
    doc2.save
    doc3.save
    Doctor.all
    expect(Doctor.search('Ma')).to eq ['Mark | Stuff','Matthew | Whatever']
  end
end
