require 'active_record'
require 'logger'
require_relative '../models/models.rb'


class MyClass
  attr_accessor :size
  
  def initialize(size)
    @size = size
  end
end