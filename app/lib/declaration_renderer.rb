class DeclarationRenderer
  include ActionView::Helpers::SanitizeHelper

  def render
    strip_tags(rendered_declaration_partial).lines.reject(&:blank?).each(&:strip!).join("\n")
  end

  def rendered_declaration_partial
    ApplicationController.renderer.new.render(partial: "shared/declaration")
  end
end
