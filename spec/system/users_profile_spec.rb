require "rails_helper"

RSpec.describe "UsersProfile", type: :system do
  before do
    driven_by(:rack_test)
    @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
    4.times do |n|
      @user.microposts.create(title: "Title #{n + 1}", content: "Post #{n + 1}")
    end
  end

  def login(user)
    visit '/login'
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    page.click_button 'Log in'
  end

  it "profile display" do
    login(@user)
    visit user_path(@user)
    expect(current_path).to eq "/users/#{@user.id}"
    expect(page.all('h1').first).to have_text @user.name
    @user.microposts.paginate(page: 1).each.with_index do |micropost, i|
      expect(page.html).to match micropost.title
      expect(page.html).to match micropost.content
    end
  end
end
