require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
  end

  get '/' do
    if session[:id].nil?
      erb :index
    else
      erb :index, :locals => {:email => @users_table[:id => session[:id]][:email], :is_admin => @users_table[:id => session[:id]][:admin]}
    end
  end

  get '/register' do
    erb :registration, :locals => {:error => nil}
  end

  post '/register' do
    email = params[:email]
    matching_password = params[:password].eql?(params[:confirmation_password])
    password_length = (params[:password].length > 3)
    is_blank = params[:password].empty?
    if matching_password && password_length && !is_blank
      password = BCrypt::Password.create(params[:password])
      session[:id] = @users_table.insert(:email => email, :password => password)
      redirect '/'
    elsif is_blank
      erb :registration, :locals => {:error => 'Please enter a password'}
    elsif !matching_password
      erb :registration, :locals => {:error => 'Passwords do not match'}
    else
      erb :registration, :locals => {:error => 'Password is too short (3 character min)'}
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/login' do
    erb :login, :locals => {:error => nil}
  end

  post '/login' do
    email = params[:email]
    password_input = params[:password]
    if @users_table[:email => email].nil? || BCrypt::Password.new(@users_table[:email => email][:password]) != password_input
      erb :login, :locals => {:error => 'Email / password is invalid.'}
    else
      session[:id] = @users_table[:email => email][:id]
      redirect '/'
    end
  end

  get '/users' do
    redirect '/error' if @users_table[:id => session[:id]].nil? || !@users_table[:id => session[:id]][:admin]

    erb :users, :locals => {:all_users => @users_table.to_a, :email => @users_table[:id => session[:id]][:email]}
  end

  get '/error' do
    erb :error
  end

  not_found do
    redirect '/error'
  end
end
