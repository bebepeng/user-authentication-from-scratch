require 'registration_requirements'
require 'spec_helper'

describe RegistrationRequirements do
  before do
    DB[:users].delete
  end

  it 'is valid with no errors if all the requirements are met' do
    req = RegistrationRequirements.new('ex@ex', 'example', 'example', DB[:users])
    expect(req.valid?).to be_true
    expect(req.error).to be_nil
  end

  it 'is invalid if the email is already taken with errors' do
    DB[:users].insert(:email => 'ex@ex', :password => 'example')
    req = RegistrationRequirements.new('ex@ex', 'example', 'example', DB[:users])
    expect(req.valid?).to be_false
    expect(req.error).to eq 'That email is already taken'
  end

  it 'is invalid if the password is blank with errors' do
    req = RegistrationRequirements.new('ex@ex', '', '', DB[:users])
    expect(req.valid?).to be_false
    expect(req.error).to eq 'Please enter a password'
  end

  it 'is invalid if the password is too short with errors' do
    req = RegistrationRequirements.new('ex@ex', 'ex', '', DB[:users])
    expect(req.valid?).to be_false
    expect(req.error).to eq 'Password is too short (3 character min)'
  end

  it 'is invalid if the passwords do not match with errors' do
    req = RegistrationRequirements.new('ex@ex', 'example', 'blah', DB[:users])
    expect(req.valid?).to be_false
    expect(req.error).to eq 'Passwords do not match'
  end
end