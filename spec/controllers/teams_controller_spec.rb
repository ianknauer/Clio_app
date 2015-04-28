require 'spec_helper'

describe TeamsController do 

  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET new" do 
    it "sets @team" do 
      get :new
      expect(assigns(:team)).to be_instance_of(Team)
    end
  end

  describe "POST update" do 
    let(:attr) do 
      Fabricate.attributes_for(:team)
    end

    before(:each) do
      @team = Fabricate(:team)
      put :update, :id => @team.id, :team => attr
      @team.reload
    end

    it "redirects to team route" do
      expect(response).to redirect_to root_path
    end

    it "updates the team attribute" do 
      expect(@team.name).to eql attr[:name]
    end
  end

  describe "POST create" do 

    context "successful team creation" do
      it "creates a team" do 
        post :create, team: Fabricate.attributes_for(:team)
        expect(Team.count).to eq(1)
      end

      it "redirects to root path" do
        post :create, team: Fabricate.attributes_for(:team)
        expect(response).to redirect_to root_path
      end
    end

    context "unsuccessful team creation" do 
      it "doesn't create a team" do 
        post :create, team: Fabricate.attributes_for(:team, name: "")
        expect(Team.count).to eq(0)
      end

      it "redirects to new" do
        post :create, team: Fabricate.attributes_for(:team, name: "")
        expect :new
      end
    end
  end

  describe "GET edit" do 
    it "takes you to the edit page" do
      @team = Fabricate(:team)
      get :edit, :id => @team.id
      expect(response).to render_template("edit")
    end
  end

  describe "POST destroy" do 
    it "should remove the team" do 
      @team = Fabricate(:team)
      post :destroy, :id => @team.id
      expect(Team.count).to eq(0)
    end

    it "should remove all references to the team from previous members" do 
      @team = Fabricate(:team)
      team_id = @team.id
      post:destroy, :id => @team.id
      expect(User.all(:conditions => ["team_id = ?", team_id]).count).to eq(0)
    end

  end
end