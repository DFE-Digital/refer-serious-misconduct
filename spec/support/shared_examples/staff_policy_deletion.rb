RSpec.shared_examples "staff policy deletion" do
  context "when deleting a staff user that is not the current staff user" do
    let(:staff_user) { create(:staff, :confirmed, :can_view_support, email: "test@test.com") }

    it { is_expected.to be true }
  end

  context "when deleting a staff user that is also the current staff user" do
    let(:staff_user) { current_staff }

    it { is_expected.to be false }
  end
end
