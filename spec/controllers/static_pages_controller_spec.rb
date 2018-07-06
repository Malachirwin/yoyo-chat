require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  before do
    @title = "Ruby on Rails Tutorial Sample App"
  end

  render_views

    it "gets home" do
      get :home
      expect(response).to have_http_status(:success)
      assert_select "title", "#{@title}"
    end

    it "gets help" do
      get :help
      expect(response).to have_http_status(:success)
      assert_select "title", "Help | #{@title}"
    end

    it "gets about" do
      get :about
      expect(response).to have_http_status(:success)
      assert_select "title", "About | #{@title}"
    end

    it "gets contact" do
      get :contact
      expect(response).to have_http_status(:success)
      assert_select "title", "Contact | #{@title}"
    end

end
