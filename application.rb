require 'sinatra/base'
require 'bcrypt'

class Application < Sinatra::Application

  enable :sessions

  def initialize(app=nil)
    super(app)
    @users_table = DB[:users]
    @users_table.delete

    # initialize any other instance variables for you
    # application below this comment. One example would be repositories
    # to store things in a database.

  end

  get '/' do
    if session[:id].nil?
      erb :index
    else
      erb :index, :locals => {:email => @users_table[:id => session[:id]][:email]}
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
end