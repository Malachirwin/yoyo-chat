require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  before do
    @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
    @other_user = User.create(name: 'Bob', email: 'bob@theirwins.ws', password: '123456', password_confirmation: '123456', activated: true, activated_at: Time.zone.now)
    @micropost = @user.microposts.create(title: "Title", content: "Body")
  end

  it "should redirect create when not logged in" do
    expect {
      post :create, params: { micropost: { title: 'Title', content: "Lorem ipsum" } }
    }.to change(Micropost, :count).by(0)
  end

  it "should redirect destroy when not logged in" do
    expect {
      delete :destroy, params: {id: @micropost.id}
    }.to change(Micropost, :count).by(0)
  end

  it "should redirect destroy for wrong micropost" do
    session[:user_id] = @other_user.id
    expect {
      delete :destroy, params: {id: @micropost.id}
    }.to change(Micropost, :count).by(0)
  end

  it "should destroy the micropost" do
    session[:user_id] = @user.id
    expect {
      delete :destroy, params: {id: @micropost.id}
    }.to change(Micropost, :count).by(-1)
  end
end
