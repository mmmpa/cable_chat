require 'capybara_helper'

feature "Chat", :type => :feature do
  before :each do |ex|
    ready_ss(ex, 800)
  end

  scenario  do
    visit '/'
    take_ss('テスト', 0.1)
    find('.room-in-button').click
    take_ss('テスト', 0.1)


  end
end
