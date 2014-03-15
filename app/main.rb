require 'sinatra/base'
require 'pry'
require 'net/smtp'
require 'logger'
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
    post_id = params[:post_id] || nil
    poll_id = params[:poll_id] || nil
    user_id = params[:user_id]
    text = params[:comment]
    
    Comment.create({:comment => text, :user_id => user_id, :post_id => post_id, :poll_id => poll_id})
    
    if post_id
      redirect to("/post/#{post_id}")
    elsif poll_id
      redirect to("/poll/#{poll_id}/result")
    else
      redirect to("/")
    end
  end
  
  get "/users" do
    @users = User.all
    erb :user_list
  end
  
  get "/user/:id" do
    @user = User.find(params[:id])
    
    erb :user
  end
  
  get "/poll/create" do
    @users = User.all
    erb :create_poll
  end
  
  get "/poll/list" do
    @polls = Poll.all
    erb :poll_list
  end
  
  post "/add/poll" do
    user_id = params[:user_id]
    question = params[:question]
    ans1 = params[:ans1]
    ans2 = params[:ans2]
    ans3 = params[:ans3]
    ans4 = params[:ans4]
    time = Time.now
    
    new_poll = Poll.create({:time => time, :active => true, :question => question, :user_id => user_id, :ans1 => ans1, :ans2 => ans2, :ans3 => ans3, :ans4 => ans4, :count1 => 0, :count2 => 0, :count3 => 0, :count4 => 0})
    
    
    redirect to("/poll/#{new_poll.id}")
  end
  
  post "/poll/:id/vote" do
    poll = Poll.find(params[:id])
    ans = params[:ans].to_i
    
    if ans == 1
      updated = poll.count1 + 1
      poll.update(:count1 => updated)
    elsif ans == 2
      updated = poll.count2 + 1
      poll.update(:count2 => updated)
    elsif ans == 3
      updated = poll.count3 + 1
      poll.update(:count3 => updated)
    elsif ans == 4
      updated = poll.count4 + 1
      poll.update(:count4 => updated)
    end 
    
    redirect to("/poll/#{poll.id}/result")
  end
  
  get "/poll/:id/result" do
    @poll = Poll.find(params[:id])
    @users = User.all
    @comments = @poll.comments
    
    erb :poll_result
  end
  
  get "/poll/:id" do
    @poll = Poll.find(params[:id])
    @users = User.all
    @comments = @poll.comments
    
    erb :poll
  end
  
end