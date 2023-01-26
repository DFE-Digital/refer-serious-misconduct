module ManageInterface
  class ReferralsController < ManageInterfaceController
    before_action :referral, only: %i[show]

    def index
      @referrals_count = Referral.submitted.count
      @pagy, @referrals = pagy(Referral.submitted)
    end

    def show
      @has_attachments = referral_zip_file.has_attachments?

      respond_to do |format|
        format.html { render "show" }
        format.zip do
          send_data(
            referral_zip_file_contents,
            filename: referral_zip_file.name
          )
        end
      end
    end

    private

    def referral
      @referral ||= Referral.find(params[:id])

      respond_to do |format|
        format.pdf do
          html = render_to_string "manage_interface/referrals/show", formats: :html
          send_data Grover.new(html, format: "A4", display_url: "http://localhost:3000/manage/referrals/4").to_pdf, type: "application/pdf"
        end
        format.html
      end
    end

    def referral_zip_file
      @referral_zip_file ||= ::ReferralZipFile.new(@referral)
    end

    def referral_zip_file_contents
      filepath = referral_zip_file.path
      file = File.open(filepath)
      contents = file.read
      file.close

      File.delete(filepath) if File.exist?(filepath)

      contents
    end
  end
end
