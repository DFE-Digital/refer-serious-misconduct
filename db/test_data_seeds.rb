staff = Staff.find_or_initialize_by(
  email: "staff@example.com",
  manage_referrals: true,
  view_support: true,
  confirmed_at: 1.second.ago,
) do |s|
  s.password = ENV.fetch("SUPPORT_PASSWORD", nil)
end

staff.save(validate: false) unless staff.persisted?
