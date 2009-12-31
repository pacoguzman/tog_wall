require 'spec_helper'

describe Wall do

  it { should have_many(:graffities) }
  it { should belong_to(:profile) }

  it "should be possible create two graffities as roots in the same wall" do
    @owner = Factory(:member).profile
    @wall = @owner.wall

    @graffity1 = Factory(:graffity, :profile => @owner, :wall => @wall)
    @graffity2 = Factory(:graffity, :profile => @owner, :wall => @wall)

    @owner.wall.graffities.should have(2).items
    @owner.wall.graffities.each {|g| g.should be_root}
  end
    
end