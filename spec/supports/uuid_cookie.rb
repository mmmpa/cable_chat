def uuid_cookie(uuid)
  request = ActionDispatch::Request.new(Rails.application.env_config)
  cookie = ActionDispatch::Cookies::CookieJar.new(request)
  cookie.signed[:uuid] = uuid
  "uuid=#{cookie['uuid']}"
end
