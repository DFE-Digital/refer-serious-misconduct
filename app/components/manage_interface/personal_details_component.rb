module ManageInterface
  class PersonalDetailsComponent < ViewComponent::Base
    include ActiveModel::Model

    attr_accessor :referral

    def rows
      rows = [
        { key: { text: "First name" }, value: { text: referral.first_name } },
        { key: { text: "Last name" }, value: { text: referral.last_name } }
      ]
      return rows unless referral.from_employer?

      rows.push(
        {
          key: {
            text: "Do they have qualified teacher status?"
          },
          value: {
            text: referral.has_qts&.humanize
          }
        }
      )
      rows
    end

    def title
      "Personal details"
    end
  end
end
