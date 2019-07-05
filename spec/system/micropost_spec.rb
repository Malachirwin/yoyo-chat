require "rails_helper"

RSpec.describe "UsersProfile", type: :system do
  before do
    driven_by(:rack_test)
    @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
    @other_user = User.create(name: 'Bob', email: 'bob@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
    4.times do |n|
      @other_user.microposts.create(title: "Title #{n + 1}", content: "Post #{n + 1}")
    end
  end

  def login(user)
    visit '/login'
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    page.click_button 'Log in'
  end

  it "micropost interface" do
    login(@user)
    visit '/'
    expect {
      fill_in 'micropost[title]', with: "Hello"
      fill_in 'micropost[content]', with: ''
      click_on 'Post'
    }.to change(Micropost, :count).by(0)
    expect(page).to have_text "Invalid Micropost!"
    content = "This micropost really ties the room together"
    expect {
      fill_in 'micropost[title]', with: "Room"
      fill_in 'micropost[content]', with: content
      click_on 'Post'
    }.to change(Micropost, :count).by(1)
    expect(page.html).to match content
    expect(page).to have_link 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    expect {
      page.find_link('delete', match: :first).click
    }.to change(Micropost, :count).by(-1)
    visit user_path(@other_user)
    expect(page).to_not have_link 'delete'
  end

  it "micropost sidebar count" do
    login(@other_user)
    visit root_path
    expect(page).to have_text "#{@other_user.microposts.length} microposts"
    login(@user)
    visit root_path
    expect(page).to have_text "0 microposts"
    @user.microposts.create!(title: 'Title', content: "A micropost")
    visit root_path
    expect(page).to have_text "#{@user.microposts.length} micropost"
  end
end
