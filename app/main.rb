require 'sinatra/base'
require 'pry'
require_relative './controllers/functions'

class Blog < Sinatra::Base
  helpers do
  end
  
  before do
  end
  
  get "/" do
    @posts = Post.last(5).reverse
    erb :home
  end
  
  get "/blogroll/:category" do
    @category = Category.find_by_name(params[:category])
    @name = @category.name
    
    @posts = Post.where("category_id = ?", @category.id).last(10).reverse
    
    erb :blogroll
  end
  
  get "/page/:title" do
    @page = Page.find_by_title(params[:title])
    
    erb :static_page
  end
  
  get "/contactus" do
    erb :contactus
  end
  
  get "/post/create" do
    @users = User.all
    @categories = Category.all
    erb :post_create
  end
  
  get "/post/:id" do
    @post = Post.find(params[:id])
    @users = User.all
    @comments = @post.comments
    
    
    erb :post
  end
  
  get "/categories" do
    new_cat = params[:category] || nil
    if new_cat
      if !Category.exists?(:name => new_cat)
        Category.create({:name => new_cat})
      else
        @retval = "#{new_cat} already exists"
      end
    end
    
    @cat = Category.all
    
    erb :category
  end
  
  post "/add/user" do
    fname = params[:fname]
    lname = params[:lname]
    uid = params[:uid]
    pw = params[:pw]
    email = params[:email]
    
    new_user = User.create({:fname => fname, :lname => lname, :email => email, :username => uid, :password => pw})
    
    redirect to("/user/#{new_user.id}")
  end
  
  post "/add/post" do
    title = params[:title]
    user_id = params[:user_id]
    category_id = params[:category_id]
    content = params[:content]
    
    new_post = Post.create({:title => title, :user_id => user_id, :category_id => category_id, :content => content, :time => Time.now, :shares => 0})
    
    redirect to("/post/#{new_post.id}")
  end
  
  post "/add/comment" do
    post_id = params[:post_id]
    user_id = params[:user_id]
    text = params[:comment]
    
    Comment.create({:comment => text, :user_id => user_id, :post_id => post_id})
    
    redirect to("/post/#{post_id}")
  end
  
  get "/users" do
    @users = User.all
    erb :user_list
  end
  
  get "/user/:id" do
    @user = User.find(params[:id])
    
    erb :user
  end
  
end