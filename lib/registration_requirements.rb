class RegistrationRequirements

  def initialize(email, password, conf_password, table)
    @email = email
    @password = password
    @conf_password = conf_password
    @table = table
  end

  def valid?
   error.nil?
  end

  def error
    if !table[:email => email].nil?
      'That email is already taken'
    elsif password.strip.empty?
      'Please enter a password'
    elsif password.length < 3
      'Password is too short (3 character min)'
    elsif password != conf_password
      'Passwords do not match'
    end
  end

  private
  attr_reader :email, :password, :conf_password, :table
end