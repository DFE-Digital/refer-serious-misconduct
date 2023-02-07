class RenderPdfJob < ApplicationJob
  def perform(referral:)
    @referral = referral

    # TODO: need to make sure the deployed domain is in the env and read it from there. Also this
    # will run on a worker instance but we need to link to the app instance
    @stylesheet = "http://localhost:3000#{ActionController::Base.helpers.asset_path("main.css")}"
    render_pdf
  end

  private

  attr_reader :referral, :stylesheet

  def render_pdf
     File.open( "test.html", "w") do |file|
       file.write(html)
     end

     File.open( "test.pdf", "wb") do |file|
       file.write(Grover.new(html, format: "A4",).to_pdf)
     end
  end

  def html
    html_renderer.render(
      template: "referrals/pdf",
      assigns: { stylesheet: },
      locals: { referral: },
      layout: false
    )
  end

  def html_renderer
    @html_renderer = ApplicationController.renderer.new
  end
end
