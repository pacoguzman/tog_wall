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

  context "#get_graffities_for" do
    before(:each) do
      @owner = Factory(:member).profile
      @wall = @owner.wall
      @graffity1 = Factory(:graffity, :profile => @owner, :wall => @wall)
      @graffity2 = Factory(:graffity, :profile => @owner, :wall => @wall)

      @friend = Factory(:member, :login => "friend").profile
      @graffity3 = Factory(:graffity, :profile => @friend, :wall => @friend.wall)
      @graffity4 = Factory(:graffity, :profile => @friend, :wall => @friend.wall)
    end

    it "should find all graffities in this wall" do
      graffities = Wall.get_graffities_for(@wall)
      @owner.wall.graffities.each do |graffity|
        graffities.should include(graffity)
      end
    end

    it "should find all graffities in these walls specified as an array" do
      graffities = Wall.get_graffities_for([@wall, @friend.wall])
      [@wall.graffities, @friend.wall.graffities].flatten.map(&:id).each do |graffity_id|
        graffities.map(&:id).should include(graffity_id)
      end
    end

    it "should find graffities with higher id" do
      graffities = Wall.get_graffities_for(@wall, :after => @graffity1)
      graffities.map(&:id).min.should >= @graffity1.id
    end

    it "should find graffities with lower id" do
      graffities = Wall.get_graffities_for(@wall, :before => @graffity4)
      graffities.map(&:id).max.should <= @graffity4.id
    end

    it "should order the graffities by descendant id" do
      Graffity.should_receive(:find).with(:all, hash_including(:order => "id DESC"))
      Wall.get_graffities_for(@wall)
    end

    it "should limit the number of graffities as default" do
      Graffity.should_receive(:find).with(:all, hash_including(:limit => Tog::Config['plugins.tog_wall.wall.pagination_size']))
      Wall.get_graffities_for(@wall)
    end

    it "should limit the number of graffities" do
      Graffity.should_receive(:find).with(:all, hash_including(:limit => 1))
      Wall.get_graffities_for(@wall, :limit => 1)
    end
  end

  context "#scoped_graffities_for" do
    context "setting a id limit" do
      it "should not set a limit" do
        Wall.scoped_graffities_for([]).proxy_options.should == []
      end

      it "should set a lower limiit" do
        Wall.scoped_graffities_for([], :after => 1).proxy_options.should == ["id > ?", 1]
      end

      it "should set a higher limit" do
        Wall.scoped_graffities_for([], :before => 2).proxy_options.should == ["id < ?", 2]
      end
    end
  end
    
end