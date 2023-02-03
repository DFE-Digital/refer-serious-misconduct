class BackLinkedErrorSummaryPresenter
  def initialize(error_messages, back_url)
    @error_messages = error_messages
    @back_url = back_url
  end

  def formatted_error_messages
    @error_messages.map do |attribute, messages|
      [attribute, messages.first, attribute == :base ? @back_url : nil].compact
    end
  end
end
