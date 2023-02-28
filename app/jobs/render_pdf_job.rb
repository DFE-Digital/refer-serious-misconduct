class RenderPdfJob < ApplicationJob
  def perform(referral:)
    @referral = referral
    @stylesheet = asset_url("main.css")
    @logo = asset_url("tra_logo.png")
    attach_pdf
  end

  private

  attr_reader :referral, :stylesheet, :logo

  def attach_pdf
    referral.pdf.attach(io:, filename:)
  end

  def html
    html_renderer.render(
      template: "referrals/pdf",
      assigns: {
        stylesheet:,
        logo:
      },
      locals: {
        referral:
      },
      layout: false
    )
  end

  def html_renderer
    @html_renderer = ApplicationController.renderer.new
  end

  def filename
    "referral-#{referral.id}.pdf"
  end

  def io
    StringIO.new(Grover.new(html, format: "A4").to_pdf)
  end

  def asset_url(asset_name)
    "#{ENV.fetch("HOSTING_DOMAIN")}#{ActionController::Base.helpers.asset_path(asset_name)}"
  end
end
