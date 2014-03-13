require 'spec_helper'

describe "My Website", :type => :feature do
  it "has a title" do
    visit("/")
    expect(page).to have_content("Title")
  end
end