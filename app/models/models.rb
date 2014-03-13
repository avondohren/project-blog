ActiveRecord::Base.establish_connection(
     :adapter => 'sqlite3',
     :database => (ENV['RACK_ENV'] == "test") ? "./app/data/blog.test" : "./app/data/blog"
)

ActiveRecord::Schema.define do
     unless ActiveRecord::Base.connection.tables.include? 'users'
          create_table :users do |table|
               #id - autoincrement integer key is created be default
               table.column :fname,       :string
               table.column :lname,       :string
               table.column :email,       :string
               table.column :username,    :string
               table.column :password,    :string
          end
     end
     
     unless ActiveRecord::Base.connection.tables.include? 'posts'
          create_table :posts do |table|
               #id - autoincrement integer key is created be default
               table.column :title,       :string
               table.column :category_id, :integer
               table.column :user_id,     :integer
               table.column :content,     :text
               table.column :time,        :datetime
               table.column :shares,      :integer
          end
     end
     
     unless ActiveRecord::Base.connection.tables.include? 'pages'
          create_table :pages do |table|
               #id - autoincrement integer key is created be default
               table.column :title,       :string
               table.column :clean_title, :string
               table.column :content,     :text
          end
     end
     
     unless ActiveRecord::Base.connection.tables.include? 'polls'
          create_table :polls do |table|
               #id - autoincrement integer key is created be default
               table.column :post_id,     :integer
               table.column :active,      :boolean
               table.column :question,    :string
               table.column :ans1,        :string
               table.column :ans2,        :string
               table.column :ans3,        :string
               table.column :ans4,        :string
               table.column :count1,      :integer
               table.column :count2,      :integer
               table.column :count3,      :integer
               table.column :count4,      :integer
          end
     end
     
     unless ActiveRecord::Base.connection.tables.include? 'categories'
          create_table :categories do |table|
               #id - autoincrement integer key is created be default
               table.column :name,        :string
          end
     end
     
     unless ActiveRecord::Base.connection.tables.include? 'comments'
          create_table :comments do |table|
               #id - autoincrement integer key is created be default
               table.column :comment,     :text
               table.column :user_id,     :integer
               table.column :post_id,     :integer
          end
     end
end

class User < ActiveRecord::Base
  has_many :post
  has_many :comment
  
  def full_name
    fname + " " + lname
  end
end

class Page < ActiveRecord::Base
end

class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_many :comments
end

class Poll < ActiveRecord::Base
end

class Category < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
end