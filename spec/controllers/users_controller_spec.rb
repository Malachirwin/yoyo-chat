require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456', admin: true)
    @other_user = User.create(name: 'Jimmy', email: 'jimmy@hiswork.com', password: '123456', password_confirmation: '123456')
  end

  it "returns http success" do
    get :new
    expect(response).to have_http_status(:success)
  end

  it "should not allow the admin attribute to be edited via the web" do
    session[:user_id] = @other_user.id
    expect(!@other_user.admin?)
    patch :update, params: { id: @other_user.id,
                             user: { password:              '123456',
                                     password_confirmation: '123456',
                                     admin: true } }
    expect(!@other_user.admin?)
  end

  it "should redirect destroy when not logged in" do
    expect {
      delete :destroy, params: { id: @user }
    }.to change(User, :count).by(0)
  end

  it "should redirect destroy when logged in as a non-admin" do
    session[:user_id] = @other_user.id
    expect {
      delete :destroy, params: { id: @user.id }
    }.to change(User, :count).by(0)
  end

  it "it deletes a user if it is the admin" do
    session[:user_id] = @user.id
    expect {
      delete :destroy, params: { id: @other_user.id }
    }.to change(User, :count).by(-1)
  end
end
