require "rails_helper"

RSpec.describe "Users", type: :system do
  describe '/signin' do
    before do
      driven_by(:rack_test)
      visit "/login"
    end

    it 'it signs in to a existing user' do
      fill_in 'session[email]', with: "malachi@theirwins.ws"
      fill_in 'session[password]', with: "123456"
      page.click_button 'Log in'
      expect(page).to have_text "Invalid email/password combination"
    end

    it 'valid login and logout' do
      expect(page).to have_text 'Log in'
      user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456')
      fill_in 'session[email]', with: "malachi@theirwins.ws"
      fill_in 'session[password]', with: "123456"
      page.click_button 'Log in'
      expect(page).to_not have_text 'Log in'
      expect(current_path).to eq "/users/#{user.id}"
      page.click_link 'Log out'
      expect(current_path).to eq "/"
      expect(page).to have_text 'Log in'
    end

    # it "login with remembering", js: true do
    #   user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456')
    #   fill_in 'session[email]', with: "malachi@theirwins.ws"
    #   fill_in 'session[password]', with: "123456"
    #   fill_in 'session[remember_me]', with: '1'
    #   page.click_button 'Log in'
    #   expect(!cookies[:remember_token].empty?)
    # end
    #
    # it "login without remembering" do
    #   user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456')
    #   fill_in 'session[email]', with: "malachi@theirwins.ws"
    #   fill_in 'session[password]', with: "123456"
    #   fill_in 'session[remember_me]', with: '1'
    #   page.click_button 'Log in'
    #   visit "/login"
    #   fill_in 'session[email]', with: "malachi@theirwins.ws"
    #   fill_in 'session[password]', with: "123456"
    #   fill_in page.find('#session_remember_me'), with: '0'
    #   page.click_button 'Log in'
    #   expect(cookies[:remember_token].empty?)
    # end
  end
end
