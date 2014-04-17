require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]

    # initialize any other instance variables for you
    # application below this comment. One example would be repositories
    # to store things in a database.

  end

  get '/' do
    if session[:id].nil?
      erb :index
    else
      erb :index, :locals => {:email => @users_table[:id => session[:id]][:email], :is_admin => @users_table[:id => session[:id]][:admin]}
    end
  end

  get '/register' do
    erb :registration
  end

  post '/register' do
    email = params[:email]
    password = BCrypt::Password.create(params[:password])
    session[:id] = @users_table.insert(:email => email, :password => password)
    redirect '/'
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
    erb :users, :locals => {:all_users => @users_table.to_a, :email => @users_table[:id => session[:id]][:email]}
  end
end
