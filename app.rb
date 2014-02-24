require 'sinatra'
require "sinatra/content_for"
require 'sqlite3'

get '/' do 
    db = SQLite3::Database.new 'newslinks.sqlite'
  @links = db.execute('SELECT id, title, description, url FROM links')
  erb :index
end

get '/edit' do
  db = SQLite3::Database.new 'newslinks.sqlite'
  @links = db.execute('SELECT id, title, description, url FROM links')
  erb :edit
end

get '/new' do
  erb :new
end

# POST to /new when we are submitting the form for a new newslink
post '/new' do
  db = SQLite3::Database.new 'newslinks.sqlite'
  db.execute('INSERT INTO links (title, description, url) VALUES(?, ?, ?)',
             [params[:title], params[:description], params[:url]])
  # The user has successfully created a newslink, redirect back to the main edit page
  redirect '/'
end

