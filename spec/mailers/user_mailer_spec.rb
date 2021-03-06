require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { User.create(name: "Malachi", email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456') }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@yoyo-chat.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi #{user.name}")
    end
  end

  describe "password_reset" do
    let(:user) { User.create(name: "Malachi", email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456') }

    it "renders the headers" do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@yoyo-chat.com"])
    end

    it "renders the body" do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      expect(mail.body.encoded).to match("To reset your password click the link below:")
      expect(mail.body.encoded).to match(user.reset_token)
    end
  end

end
