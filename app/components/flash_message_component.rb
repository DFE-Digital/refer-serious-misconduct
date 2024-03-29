# frozen_string_literal: true
class FlashMessageComponent < ViewComponent::Base
  ALLOWED_PRIMARY_KEYS = %i[warning success].freeze
  DEVISE_PRIMARY_KEYS = { alert: :warning, notice: :success }.freeze

  def initialize(flash:)
    super
    @flash = flash.to_hash.symbolize_keys!
  end

  def message_key
    key =
      flash.keys.detect do |k|
        ALLOWED_PRIMARY_KEYS.include?(k) || DEVISE_PRIMARY_KEYS.keys.include?(k)
      end
    DEVISE_PRIMARY_KEYS[key] || key
  end

  def title
    I18n.t(message_key, scope: :notification_banner)
  end

  def classes
    "govuk-notification-banner--#{message_key}"
  end

  def role
    %i[warning success].include?(message_key) ? "alert" : "region"
  end

  def heading
    messages.is_a?(Array) ? messages[0] : messages
  end

  def body
    tag.p(messages[1], class: "govuk-body") if messages.is_a?(Array) && messages.count >= 2
  end

  def render?
    !flash.empty? && message_key
  end

  private

  def messages
    flash[message_key] || flash[DEVISE_PRIMARY_KEYS.key(message_key)]
  end

  attr_reader :flash
end
