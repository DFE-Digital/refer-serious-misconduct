RSpec.shared_examples "email with `Get help` section" do
  it "includes the header" do
    expect(email.body).to include("Get help")
  end

  it "includes the contact email" do
    expect(email.body).to include("misconduct.teacher@education.gov.uk")
  end

  it "includes the contact phone number" do
    expect(email.body).to include("020 7593 5393")
  end
end
