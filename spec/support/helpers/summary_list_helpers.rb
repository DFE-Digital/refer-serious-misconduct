module SummaryListHelpers
  def expect_summary_row(key:, value:, change_link: nil, exact_text: false)
    page_find_options = { text: key }.merge(exact_text:)

    row =
      page.find(".govuk-summary-list__key", **page_find_options).ancestor(
        ".govuk-summary-list__row"
      )

    within(row) do
      expect(find(".govuk-summary-list__value").text).to match(value)
      if change_link
        expect(find(".govuk-summary-list__actions")).to have_link("Change", href: change_link)
      end
    end
  end
end
