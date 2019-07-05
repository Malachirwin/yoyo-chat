require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { User.create(name: "Malachi", email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456') }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@sampleapp.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi #{user.name}")
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["no-reply@sampleapp.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
