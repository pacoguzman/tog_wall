require 'spec_helper'

describe Graffity do

#  it { should belong_to(:wall) }
#  it { should belong_to(:profile) }
#  it { should have_many(:replies) }

  it "is not valid without a comment" do
    @owner = Factory(:member, :login => "ownerious")
    @visitor = Factory(:member, :login => "visitorious")

    graffity = Graffity.new(:wall => @owner.profile.wall, :profile => @visitor.profile)
    graffity.should_not be_valid
  end

  describe "build_from" do
    before(:each) do
      @wall = Wall.new
      @wall.stub(:profile)
    end

    it "should return a graffity instance" do
      Graffity.build_from(@wall, nil, {}).should be_instance_of(Graffity)
    end

    it "should set type_common as true by default" do
      graffity = Graffity.build_from(@wall, nil, {})
      graffity.type_common.should be_true
    end

    it "passing type_common as false should override the default type_common" do
      graffity = Graffity.build_from(@wall, nil, {:type_common => false})
      graffity.type_common.should be_false
    end

    it "should set wall with the wall passed" do
      graffity = Graffity.build_from(@wall, nil, {})
      graffity.wall.should == @wall
    end

    it "should set profile with the profile passed" do
      profile = Profile.new
      graffity = Graffity.build_from(@wall, profile, {})
      graffity.profile.should == profile
    end

    it "should set title with the title passed" do
      graffity = Graffity.build_from(@wall, nil, {:title => "Hello, world"})
      graffity.title.should == "Hello, world"
    end

    it "should set comment with the comment passed" do
      graffity = Graffity.build_from(@wall, nil, {:comment => "Bazzinga!"})
      graffity.comment.should == "Bazzinga!"
    end


  end

end