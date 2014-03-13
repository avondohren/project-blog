require 'spec_helper'

describe MyClass do
  before(:each) do
  	@size = 5
    @my_object = MyClass.new(@size)
  end
  
  it "has a size" do
    expect(@my_object.size).to eq(@size)
  end
end