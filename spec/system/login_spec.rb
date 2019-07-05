require "rails_helper"

RSpec.describe "Users", type: :system do
  def login(user)
    visit '/login'
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    page.click_button 'Log in'
  end

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
      user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
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
  describe '/users/index' do
    before do
      @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', admin: true, activated: true, activated_at: Time.zone.now)
      @other_user = User.create(name: 'Jimmy', email: 'jimmy@hiswork.com', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
      driven_by(:rack_test)
      visit "/login"
    end

    it 'only lets you view the users when logged in' do
      visit '/users'
      expect(page).to have_text "Please Login First."
      visit '/login'
      user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
      User.create(name: 'Jimmy', email: 'jimmy@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)

      fill_in 'session[email]', with: "malachi@theirwins.ws"
      fill_in 'session[password]', with: "123456"
      page.click_button 'Log in'
      visit '/users'
      expect(page).to have_text 'Users'
      expect(page).to have_link 'Malachi'
      expect(page).to have_link 'Jimmy'
    end

    it "index including pagination" do
      visit '/login'
      user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
      User.create(name: 'Jimmy', email: 'jimmy@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)

      fill_in 'session[email]', with: "malachi@theirwins.ws"
      fill_in 'session[password]', with: "123456"
      page.click_button 'Log in'
      visit '/users'
      User.paginate(page: 1).each do |user|
        expect(page).to have_link user.name
      end
    end

    it "index as non-admin" do
      login(@other_user)
      visit users_path
      expect(page).to_not have_link 'delete'
    end

    it "index as admin" do
      login(@user)
      visit users_path
      expect(page).to have_link 'delete'
    end
  end
end
