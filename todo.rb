require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  session[:lists] ||= []
end

helpers do
  # Return an error message if the name is invalid. Return nil if name is valid.
  def list_error(list_name)
    if !(1..100).cover? list_name.size
      'The list name must be between 1 and 100 characters.'
    elsif session[:lists].any? { |list| list[:name] == list_name }
      'List name must be unique.'
    end
  end
end

# GET /lists        -> view all lists
# GET /lists/new    -> new list form
# POST /lists       -> create new list
# GET /lists/:id    -> view a single list

get '/' do
  redirect '/lists'
end

# View all lists
get '/lists' do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# Create a new list
post '/lists' do
  list_name = params[:list_name].strip

  error = list_error(list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << { name: list_name, todos: [] }
    session[:success] = 'The list has been created.'
    redirect '/lists'
  end
end

# Render the new list form
get '/lists/new' do
  erb :new_list, layout: :layout
end
