def mount_path
  @mount_path ||= begin
    mount = Rails.application.config.action_cable.mount_path
    host = Capybara.current_session.server.host
    port = Capybara.current_session.server.port
    "http://#{host}:#{port}#{mount}"
  end
end
