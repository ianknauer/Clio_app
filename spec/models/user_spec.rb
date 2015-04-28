require 'spec_helper'

describe User do

  it { should belong_to(:team) }

  let(:user) { create(:user) }

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
