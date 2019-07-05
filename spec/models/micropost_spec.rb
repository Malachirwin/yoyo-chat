require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = User.create(name: 'Malachi', email: 'malachi@theirwins.ws', password: '123456', password_confirmation: '123456')
    @micropost = @user.microposts.build(title: 'First Post', content: "Lorem ipsum")
    @most_recent = @user.microposts.build(title: 'Second Post', content: "Lorem2 ipsum2")
  end

  it "should be valid" do
    expect(@micropost.valid?).to eq true
  end

  it "user id should be present" do
    @micropost.user_id = nil
    expect(@micropost.valid?).to eq false
  end

  it "content should be present" do
    @micropost.content = "   "
    expect(@micropost.valid?).to eq false
  end

  it "content should be at most 140 characters" do
    @micropost.content = "a" * 251
    expect(@micropost.valid?).to eq false
  end

  it "title should be at most 15 characters" do
    @micropost.title = "a" * 31
    expect(@micropost.valid?).to eq false
  end

  it "title should be at minimum 2 characters" do
    @micropost.title = "a"
    expect(@micropost.valid?).to eq false
  end

  it "order should be most recent first" do
    @micropost.save
    @most_recent.save
    expect(@most_recent).to eq Micropost.first
  end
end
