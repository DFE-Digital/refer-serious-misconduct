module ValidationErrorHelper
  def humanized_form_object(form_object)
    if form_object.starts_with? "Referrals::"
      "#{form_object.split("::").second.underscore.titleize} / #{form_object.split("::").last.underscore.titleize}"
    else
      form_object.underscore.titleize
    end
  end
end
