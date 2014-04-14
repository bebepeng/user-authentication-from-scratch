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
    erb :index
  end

  get '/register' do
    erb :registration
  end

  post '/register' do
    email = params[:email]
    password = BCrypt::Password.create(params[:password])
    session[:id] = @users_table.insert(:email => email, :password => password)
    redirect '/home'
  end

  get '/home' do
    erb :home, :locals => {:email => @users_table[:id => session[:id]][:email]}
  end

end