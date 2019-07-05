require "rails_helper"

RSpec.describe "Users", type: :system do
  describe '/edit' do
    def login(user)
      visit '/login'
      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      page.click_button 'Log in'
    end

    before do
      driven_by(:rack_test)
      @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
      @other_user = User.create(name: 'Bob', email: 'bob@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)

    end

    it "doesn't update if it is invalid" do
      login(@user)
      visit "/users/#{@user.id}/edit"
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: "malachi@theirw"
      fill_in 'user[password]', with: "123456"
      page.click_button 'Save changes'
      # expect(current_path).to eq "/users/#{@user.id}/edit"
      expect(page).to have_text "Name can't be blank"
    end

    it "updates if it is valid" do
      login(@user)
      visit "/users/#{@user.id}/edit"
      fill_in 'user[name]', with: 'Name'
      fill_in 'user[email]', with: "malachi@irwins.ws"
      page.click_button 'Save changes'
      # expect(current_path).to eq "/users/#{@user.id}/edit"
      expect(page).to have_text "Profile Successfully Updated!"
      expect(current_path).to eq "/users/#{@user.id}"
    end

    it "redirects to the correct page if it is the worng user" do
      login(@user)
      visit "/users/#{@other_user.id}/edit"
      expect(current_path).to eq "/users/#{@user.id}/edit"
    end

    it "should redirect edit when not logged in" do
      visit edit_user_path(@user)
      expect(page).to have_text "Please Login First."
      expect(current_path).to eq '/login'
    end
  end
end
