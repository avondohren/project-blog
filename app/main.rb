require 'sinatra/base'
require 'pry'
require 'net/smtp'
require_relative './controllers/functions'

class Blog < Sinatra::Base
  helpers do
    def underscore(string)
      string.split(" ").join("_")
    end
  end
  
  before do
  end
  
  get "/" do
    @page = params[:page].to_i || 0
    offset = (@page * 5)
    @posts = Post.order('time DESC').offset(offset).first(5)
    erb :home
  end
  
  get "/blogroll/:category" do
    @page = params[:page].to_i || 0
    offset = (@page * 5)
    @category = Category.find_by_name(params[:category])
    @name = @category.name
    
    @count = Post.where("category_id = ?", @category.id).length
    @posts = Post.where("category_id = ?", @category.id).order('time DESC').offset(offset).first(5)
    
    erb :blogroll
  end
  
  get "/page/create" do
    erb :create_page
  end
  
  get "/page/:title" do
    @page = Page.where("clean_title = ?", params[:title]).first
    
    erb :static_page
  end
  
  get "/contact_us" do
    erb :contactus
  end
  
  post "/contact_us/submit" do
    # sudo postfix start
    message = "From: Private Person <me@fromdomain.com>
    To: Andy von Dohren <avondohren@gmail.com>
    MIME-Version: 1.0
    Content-type: text/html
    Subject: SMTP e-mail test

    You have received the following communication from MyBlog:
    Name: #{params[:name]}
    Email: #{params[:email]}
    Comment/Question: #{params[:body]}
    
    Thanks!"

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message message, 'contactus@myblog.com', 
                                 'avondohren@gmail.com'
    end
    
    erb :thanks
  end
  
  get "/post/create" do
    @users = User.all
    @categories = Category.all
    erb :create_post
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
  
  post "/add/page" do
    title = params[:title]
    clean_title = underscore(title)
    text = params[:text]
    
    new_page = Page.create({:title => title, :clean_title => clean_title, :content => text})
    
    redirect to("/page/#{clean_title}")
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