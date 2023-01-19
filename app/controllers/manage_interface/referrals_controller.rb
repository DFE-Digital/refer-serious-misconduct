module ManageInterface
  class ReferralsController < ManageInterfaceController
    before_action :referral, only: %i[show download]

    def index
      @referrals_count = Referral.submitted.count
      @pagy, @referrals = pagy(Referral.submitted)
    end

    def show
    end

    def download
      filepath = @referral.zip_file_path
      file = File.open(filepath)
      contents = file.read
      file.close

      File.delete(filepath) if File.exist?(filepath)

      send_data(contents, filename: @referral.zip_file_name)
    end

    private

    def referral
      @referral ||= Referral.find(params[:id])
    end
  end
end
