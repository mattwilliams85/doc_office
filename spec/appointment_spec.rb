require 'spec_helper'

describe Appointment do
  it 'initializes with patient, date, cost, doctor and id' do
    test_appointment = Appointment.new(0,'',0.00,0,0)
    expect(test_appointment).to be_an_instance_of Appointment
  end

  it 'starts with no appointments in the system' do
    expect(Appointment.all).to eq []
  end

  it 'lets you create an appointment' do
    test_appointment = Appointment.new(0,'',0.00,0,0)
    create_var
    save_var
    test_appointment.create_appointment('Sam','07261985','10.00',0)
    expect(test_appointment.date).to_not eq ''
  end

  it 'is the same appointment if it has the same id' do
    app1 = Appointment.new(0,'',0.00,0,0)
    app2 = Appointment.new(0,'',0.00,0,0)
    expect(app1).to eq app2
  end


  it 'lets you save appointments to the database' do
    test_appointment = Appointment.new(0,'',0.00,0,0)
    test_appointment.save
    expect(Appointment.all).to eq [test_appointment]
  end



  it 'allows you to delete an appointment' do
    test_appointment = Appointment.new(2,'08032014',20.50,2,1)
    test_appointment.save
    pat1 = Patient.new('Kate','54382943',2, 0)
    pat1.save
    pat1.delete_appt('Kate')

    expect(Appointment.all).to eq []
  end
 end
