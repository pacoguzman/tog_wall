require 'spec_helper'

describe Profile do

  it { should have_one(:wall) }

  it "should have a wall after create the profile" do
    @user = Factory(:member)
    @user.profile.wall.should be_instance_of(Wall)
    @user.profile.wall.should_not be_a_new_record
  end
end