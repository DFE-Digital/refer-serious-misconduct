module ReferrerHelper
  def address(referral)
    [
      referral.address_line_1,
      referral.address_line_2,
      referral.town_or_city,
      referral.postcode,
      referral.country
    ].compact_blank.join("<br>").html_safe
  end
end
