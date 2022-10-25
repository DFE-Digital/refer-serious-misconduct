class ReferralsController < ApplicationController
  def new
    @referral_form = ReferralForm.new(referral: Referral.new)
  end

  def edit
    @referral_form = ReferralForm.new(referral:)
  end

  def update
    @referral_form = ReferralForm.new(referral:)

    if @referral_form.save
      # TODO: TBC
    else
      render :edit
    end
  end

  def destroy
    referral.destroy!
    redirect_to start_path
  end

  private

  def referral
    # TODO: This needs integration with current_user check
    @referral ||= Referral.find(params[:id])
  end
end
