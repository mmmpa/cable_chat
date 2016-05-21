def mount_path
  @mount_path ||= begin
    mount = Rails.application.config.action_cable.mount_path
    test_host + mount
  end
end

def test_host
  host = Capybara.current_session.server.host
  port = Capybara.current_session.server.port
  "http://#{host}:#{port}"
end
