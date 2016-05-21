require 'capybara_helper'

feature "Connect", :type => :feature do
  before :each do |ex|
    ready_ss(ex, 800)
  end

  let(:cookie) { "uuid=#{page.driver.cookies['uuid'].value}" }
  let(:ws) { WebSocket::Client::Simple.connect(mount_path, headers: {'Cookie' => cookie}) }
  let(:rejection_type) { ActionCable::INTERNAL[:message_types][:rejection] }
  let(:connected_type) { ActionCable::INTERNAL[:message_types][:welcome] }


  scenario 'receive my data when has session' do
    visit '/'
    find('.room-in-name').set('aaaa')
    find('.room-in-button').click
    find('.room-member')
    find('.room-message').click
    find('.message-container textarea').set('message')
    find('.message-container button').click

    take_ss('ss', 1)
  end

  scenario '2' do
    visit '/'
    find('.room-in-name').set('aaaa')
    find('.room-in-button').click
    find('.room-member')
    page.driver.click(500, 100)
    find('.message-container textarea').set('message')
    find('.message-container button').click

    abcd = Friend.new(Capybara::Session.new(:poltergeist), test_host, 'abcd')
    abcd.say(600, 100, 'say say say')


    efg = Friend.new(Capybara::Session.new(:poltergeist), test_host, 'efg')
    efg.say(600, 200, 'say say say')

    take_ss('ss', 1)
  end
end

class Friend
  def initialize(session, url, name)
    @session = session
    @session.visit(url)
    @session.find('.room-in-name').set(name)
    @session.find('.room-in-button').click
    @session.find('.room-member')
  end

  def say(x, y, message)
    @session.driver.click(x, y)
    @session.find('.message-container textarea').set(message)
    @session.find('.message-container button').click
  end
end