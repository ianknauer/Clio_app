require 'spec_helper'

describe UsersController do
  

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET index" do
    before { get :index }

    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "GET statuses" do 
    let(:bob) { create(:user) }

    before(:each) do 
      get 'statuses', :format => :json
    end

    it "makes a valid request", :type => :request do
      response.should be_success
    end
  end

  describe "POST boot" do 
    it "should remove user from team" do 
    end
  end

  describe "POST add" do
  end

  describe "PATCH update" do

    before :each do 
      @bob = create(:user)
    end

    context "with invalid attributes" do 
      @bob.email = nil
      put :update, id: @bob
      expect(@bob.email).no_to be_nil
    end

    context "with valid attributes" do 
    end
  end
end
