Rack::Attack.throttle("limit_otp_emails", limit: 10, period: 1.minute) do |req|
  req.ip if req.path.match(%r{/users/session}) && req.post?
end
