module SummaryListHelpers
  def expect_summary_row(key:, value:, change_link:)
    within(page.find(".govuk-summary-list__row", text: key)) do
      expect(find(".govuk-summary-list__value").text).to match(value)
      expect(find(".govuk-summary-list__actions")).to have_link(
        "Change",
        href: change_link
      )
    end
  end
end
