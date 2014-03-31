require 'sinatra'
require "sinatra/content_for"
require 'sqlite3'

get '/' do 
  db = SQLite3::Database.new 'newslinks.sqlite'
  @links = db.execute('SELECT id, title, description, url, category_id FROM links')
  categories = db.execute('SELECT id, name FROM categories')  # [ [1, 'World news'], [2, 'Local News'], ... ]
  @category_id_to_name = Hash[categories]
  
  @category_id_to_links = {}
  @links.each do |link|
    link_category_id = link[4]
    if @category_id_to_links.has_key?(link_category_id)
      @category_id_to_links[link_category_id] << link
    else
      @category_id_to_links[link_category_id] = [link]
    end
  end
  puts @category_id_to_links.inspect
  
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
  db.execute('INSERT INTO links (title, description, url, category_id) VALUES(?, ?, ?, ?)',
    [params[:title], params[:description], params[:url], params[:category_id]])
  # The user has successfully created a newslink, redirect back to the main edit page
  redirect '/edit'
end

get '/edit/:id' do
  db = SQLite3::Database.new 'newslinks.sqlite'
  links = db.execute('SELECT id, title, description, url FROM links WHERE id = ?', [params[:id]])
  @link = links[0]
  erb :update
end

post '/edit/:id' do
  db = SQLite3::Database.new 'newslinks.sqlite'
  db.execute('UPDATE links SET title=?, description=?, url=? WHERE id=?', [params[:title], params[:description], params[:url], params[:id]])
  redirect '/edit'
end

post '/delete/:id' do
  db = SQLite3::Database.new 'newslinks.sqlite'  
  db.execute('DELETE FROM links WHERE id=?', [params[:id]])
  redirect '/edit'
end
  
# Why does the id for the two handlers above automatically take the :id parameters. Why doesn't title or description use it? 

# CRUD:
# Create
# Retrieve/Read
# Update
# Delete/Destroy

# @links == [ [1, "techcrunch", "cool technology and companies", "techcrunch.com"] ]
# @links[0] # [1, "techcrunch", "cool technology and companies", "techcrunch.com"]
# @links[0][0] #