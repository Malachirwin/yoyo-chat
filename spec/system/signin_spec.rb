require "rails_helper"

RSpec.describe "Users", type: :system do
  describe '/signin' do
    before do
      driven_by(:rack_test)
      visit "/signup"
    end

    it 'does not create a user if it is invalid signs in' do
      before_count = User.count
      fill_in 'user[name]', with: ""
      fill_in 'user[email]', with: "foo@invalid"
      fill_in 'user[password]', with: "foo"
      fill_in 'user[password_confirmation]', with: "bar"
      page.click_on 'Create my account'
      expect(page).to have_text "Name can't be blank"
      expect(before_count).to eq User.count
    end

    it 'valid signup' do
      before_count = User.count
      fill_in 'user[name]', with: "Malachi"
      fill_in 'user[email]', with: "malachi@theirwins.ws"
      fill_in 'user[password]', with: "123456"
      fill_in 'user[password_confirmation]', with: "123456"
      page.click_on 'Create my account'
      expect(page).to have_text 'Welcome to the Sample App!'
      expect(before_count + 1).to eq User.count
    end
  end
end
