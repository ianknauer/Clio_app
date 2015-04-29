require 'spec_helper'

describe UsersController do  

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET index" do
    before do
      @bob = create(:user)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    context "user isn't part of a team" do 
      it "assigns all other users to @other_users" do 
        get :index
        expect(assigns(:other_users)).to match_array [@bob]
      end
      it "doesn't create @team users" do 
        get :index
        expect(assigns(:team_users)).to be_nil
      end
    end

    context "user is part of a team" do 
      before do 
        @customer_service = Fabricate(:team)
        user.team = @customer_service
        user.save
        @anne = create(:user, team: @customer_service)
      end

      it "assigns team members to @team_users" do
        get :index
        expect(assigns(:team_users)).to match_array [@anne]
      end
      it "assigns others to @other_users" do 
        get :index
        expect(assigns(:other_users)).to match_array [@bob]
      end
    end
  end

  describe "GET statuses" do 
    before(:each) do 
      get 'statuses', :format => :json
    end

    it "makes a valid request", :type => :request do
      response.should be_success
    end
  end

  describe "POST boot" do 
    before do 
      @customer_service = Fabricate(:team)
      user.team = @customer_service
      user.save
      @bob = create(:user, team: @customer_service)
    end

    it "should remove user from team" do
      put :boot, id: @bob
      expect(@bob.reload.team_id).to be_nil
    end

    it "should redirect to root path" do 
      put :boot, id: @bob
      expect(response).to redirect_to root_path
    end
  end

  describe "POST add" do
    before do 
      @customer_service = Fabricate(:team)
      user.team = @customer_service
      user.save
    end

    context "member is available for team" do 
      before do 
        @bob = create(:user)
      end

      it "should add member to team" do 
        put :add, id: @bob
        expect(@bob.reload.team_id).to eq(user.team_id)
      end
    end

    context "member is not available for team" do
      before do 
        @bob = create(:user, team: @customer_service)
      end

      it "should provide an error" do
        put :add, id: @bob
        expect(flash[:error]).to eq("That person is already on a team")
      end
    end
    it "should redirect to root_path" do
      @bob = create(:user) 
      put :add, id: @bob
      expect(response).to redirect_to root_path
    end
  end

  describe "POST update" do 
    context "valid user update" do 
      let(:attr) do 
        { :email => "new.email@email.com" }
      end

      it "should redirect_to root_path" do 
        put :update, id: user, :user => attr
        expect(response).to redirect_to root_path
      end
      it "should update the user" do 
        put :update, id: user, :user => attr
        user.reload
        expect(user.email).to eql("new.email@email.com")
      end
    end
    context "invalid user info for update" do 
      let(:attr) do 
        { :email => nil }
      end

      it "should not update user" do 
        put :update, id: user, :user => attr
        user.reload
        expect(user.email).not_to be_nil
      end
    end
  end
end
