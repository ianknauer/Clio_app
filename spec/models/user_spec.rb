require 'spec_helper'

describe User do

  it { should belong_to(:team) }

  let(:user) { create(:user) }

  it "returns a users full name as a string" do 
    user = User.new(first_name: "ian", last_name: 'knauer', email: 'ian.knauer@gmail.com')
    expect(user.full_name).to eq 'ian knauer'
  end

  describe "#team_members" do
    before do 
      creative_services = Fabricate(:team)
      user.team = creative_services
      user.save
      @bob = create(:user, team: creative_services)
    end
    it "returns an array of other team members" do 
      expect(User.team_members(user)).to eq [@bob]
    end
    it "should not include members not in team" do 
      anne = create(:user)
      expect(User.team_members(user)).to eq [@bob]
    end
  end

  describe "#other_members" do 
    before do 
      @digital_strategy = Fabricate(:team)
      user.team = @digital_strategy
      user.save
      @bob = create(:user, team: @digital_strategy)
    end
    it "returns an array of other members" do 
      @anne = create(:user)
      expect(User.other_members(user)).to eq [@anne]
    end

    it "should not include members in team" do 
      expect(User.other_members(user)).to eq []
    end
  end

  describe "#status=" do
    before do
      user.status = status
    end

    context "when given an accepted value" do
      let(:status) { :in }
      it "writes the enumerated value in the database" do
        expect(user.send(:read_attribute, :status)).to eql User::STATUSES[status]
      end
    end

    context "when given an unacceptable value" do
      let(:status) { :bad_status }
      it "writes nil in the database" do
        expect(user.send(:read_attribute, :status)).to be_nil
      end
    end
  end

  describe "available_for_team?" do
    it "should be true when team id is nil" do 
      expect(user.available_for_team?).to be_true
    end

    it "should be false when assigned to a team" do 
      team = Fabricate(:team)
      user.team = team
      user.save
      expect(user.available_for_team?).to be_false
    end
  end
end
