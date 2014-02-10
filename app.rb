require 'sinatra'
require 'sqlite3'

get '/' do 
  erb :index
end

get '/edit' do
  erb :edit
end

get '/new' do
  erb :new
end

post '/new' do
  db = SQLite3::Database.new 'newslinks.sqlite'
  db.execute('INSERT INTO links (id, title, description, url) VALUES(?, ?, ?, ?)',
             [1, params[:title], params[:description], params[:url]]) 
  redirect '/edit'
end

