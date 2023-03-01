RSpec.shared_examples "staff policy with permission" do |permission|
  context "with permission" do
    let(:user) { create(:staff, :confirmed, permission) }

    it { is_expected.to be true }
  end

  context "with AnonymousSupportUser" do
    let(:user) { AnonymousSupportUser.new }

    it { is_expected.to be false }
  end
end
