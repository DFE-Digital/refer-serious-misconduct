module AddressHelper
  def address(referral)
    address_fields_to_html(
      [
        referral.address_line_1,
        referral.address_line_2,
        referral.town_or_city,
        referral.postcode,
        referral.country
      ]
    )
  end

  def organisation_address(organisation)
    address_fields_to_html(
      [
        organisation&.name,
        organisation&.street_1,
        organisation&.street_2,
        organisation&.city,
        organisation&.postcode
      ]
    )
  end

  def referral_organisation_address(referral)
    address_fields_to_html(
      [
        referral.organisation_name,
        referral.organisation_address_line_1,
        referral.organisation_address_line_2,
        referral.organisation_town_or_city,
        referral.organisation_postcode
      ]
    )
  end

  def teaching_address(referral)
    address_fields_to_html(
      [
        referral.work_organisation_name,
        referral.work_address_line_1,
        referral.work_address_line_2,
        referral.work_town_or_city,
        referral.work_postcode
      ]
    )
  end

  private

  def address_fields_to_html(address)
    return unless address.any?

    address.compact_blank.join("<br />").html_safe
  end
end
