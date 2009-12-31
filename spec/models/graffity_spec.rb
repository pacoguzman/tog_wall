require 'spec_helper'

describe Graffity do

  it { should belong_to(:wall) }
  it { should belong_to(:profile) }
  it { should have_many(:replys) }

  it "is not valid without a comment" do
    @owner = Factory(:member, :login => "ownerious")
    @visitor = Factory(:member, :login => "visitorious")

    graffity = Graffity.new(:wall => @owner.profile.wall, :profile => @visitor.profile)
    graffity.should_not be_valid
  end

end