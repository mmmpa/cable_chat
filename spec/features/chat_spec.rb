require 'capybara_helper'

feature "Connect", :type => :feature do
  before { |ex| ready_ss(ex, 800) }

  after dZo
    reset_session!
    User.delete_all
  end

  let(:cookie) { "uuid=#{page.driver.cookies['uuid'].value}" }
  let(:ws) { WebSocket::Client::Simple.connect(mount_path, headers: {'Cookie' => cookie}) }
  let(:rejection_type) { ActionCable::INTERNAL[:message_types][:rejection] }
  let(:connected_type) { ActionCable::INTERNAL[:message_types][:welcome] }

  scenario '入室失敗' do
    visit '/'
    find('.room-in-name')
    take_ss('初期')
    find('.room-in-button').click
    find('.room-in-error')
    take_ss('エラー表示')
  end

  scenario '入室から退室まで' do
    visit '/'
    find('.room-in-name')
    take_ss('初期')
    find('.room-in-name').set('aaaa')
    take_ss('名前入力')
    find('.room-in-button').click
    find('.room-member')
    take_ss('入室ずみ')
    page.driver.click(500, 100)
    take_ss('メッセージボックス表示')
    find('.message-container textarea').set('message')
    take_ss('メッセージ入力')
    find('.message-container button').click
    find('.room-message .message-box')
    take_ss('メッセージ送信後')
    find('.room-out-button').click
    find('.room-in-name')
    take_ss('退室後')
  end

  scenario '複数ウィンドウでの入室退室' do
    window1 = current_window
    window2 = open_new_window

    switch_to_window(window2)

    visit '/'
    find('.room-in-name')
    find('.room-in-name').set('aaaa')
    find('.room-in-button').click
    find('.room-member')
    take_ss('window2_入室ずみ')

    switch_to_window(window1)
    visit '/'
    take_ss('window1_開いた段階で入室ずみ')

    find('.room-member')
    find('.room-out-button').click
    find('.room-in-name')
    take_ss('window1_退室済み')

    switch_to_window(window2)

    find('.room-in-name')
    take_ss('window2_自動退室済み')
  end

  scenario '入室済みの場合、そちらの名前が優先' do
    window1 = current_window
    window2 = open_new_window

    visit '/'
    switch_to_window(window2)

    visit '/'
    find('.room-in-name')
    find('.room-in-name').set('aaaa')
    find('.room-in-button').click
    find('.room-member')
    take_ss('window2_aaaaで入室ずみ')

    switch_to_window(window1)

    find('.room-in-name').set('abcd')
    take_ss('window1_abcdで入室')
    find('.room-in-button').click
    find('.room-member .name')
    take_ss('window1_aaaaで入室扱い')

    window1.session.reset_session!
    window2.session.reset_session!
  end


  scenario 'マルチユーザー' do
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

    abcd.away
    efg.away
  end

  scenario 'スクリーンショット' do
    u2 = Friend.new(Capybara::Session.new(:poltergeist), test_host, 'TK')
    visit '/'
    find('.room-in-name').set('o296sm')
    find('.room-in-button').click
    find('.room-member')

    say_in_current(page, 210, 160, 'オキシジェンゲッチューハァイ！')

    u1 = Friend.new(Capybara::Session.new(:poltergeist), test_host, 'MMMPA')
    u1.say(600, 100, 'The first rule of Fight Club')


    u2.say(650, 200, 'きみらなんや')

    say_in_current(page, 670, 250, '酢で中和しましょう！')
    u2.say(675, 310, 'やめろ')
    say_in_current(page, 710, 295, '酢で中和しましょう！')
    page.driver.click(220, 300)

    take_ss('ss', 1)

    u1.away
    u2.away
  end
end

def say_in_current(current, x, y, message)
  current.driver.click(x, y)
  current.find('.message-container textarea').set(message)
  current.find('.message-container button').click
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
    say_in_current(@session, x, y, message)
  end

  def away
    @session.reset_session!
  end
end