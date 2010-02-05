require 'spec_helper'

describe Wall do

#  it { should have_many(:graffities) }
#  it { should belong_to(:profile) }

  it "should be able to create two graffities as root in the same wall" do
    @owner = Factory(:member).profile
    @wall = @owner.wall

    @graffity1 = Factory(:graffity, :profile => @owner, :wall => @wall)
    @graffity2 = Factory(:graffity, :profile => @owner, :wall => @wall)

    @owner.wall.graffities.should have(2).items
    @owner.wall.graffities.each {|g| g.should be_root}
  end

  describe "#get_graffities_for" do
    before(:each) do
      @owner = Factory(:member).profile
      @wall = @owner.wall
      @graffity1 = Factory(:graffity, :profile => @owner, :wall => @wall)
      @graffity2 = Factory(:graffity, :profile => @owner, :wall => @wall)

      @friend = Factory(:member, :login => "friend").profile
      @graffity3 = Factory(:graffity, :profile => @friend, :wall => @friend.wall)
      @graffity4 = Factory(:graffity, :profile => @friend, :wall => @friend.wall)
    end

    it "passing one wall should find all graffities in that wall" do
      graffities = Wall.get_graffities_for(@wall)
      @wall.graffities.each do |graffity|
        graffities.should include(graffity)
      end
    end

    it "passing an array of walls should find all graffities in these walls" do
      graffities = Wall.get_graffities_for([@wall, @friend.wall])
      [@wall.graffities, @friend.wall.graffities].flatten.map(&:id).each do |graffity_id|
        graffities.map(&:id).should include(graffity_id)
      end
    end

    it "passing one wall and after option should find graffities with id higher than the specified in the after option" do
      graffities = Wall.get_graffities_for(@wall, :after => @graffity1.id)
      graffities.each do |graffity|
        graffity.id.should >= @graffity1.id
      end
    end

    it "passing one wall and after option should find graffities with id lower than the specified in the after option" do
      graffities = Wall.get_graffities_for(@wall, :before => @graffity4)
      graffities.each do |graffity|
        graffity.id.should <= @graffity4.id
      end
    end

    it "should order the graffities by descendant id by default" do
      Graffity.should_receive(:find).with(:all, hash_including(:order => "id DESC"))
      
      Wall.get_graffities_for(@wall)
    end

    it "should limit the number of graffities by default" do
      Graffity.should_receive(:find).with(:all, hash_including(:limit => Tog::Config['plugins.tog_wall.wall.pagination_size']))
      Wall.get_graffities_for(@wall)
    end

    it "passing a limit option should override the default limit" do
      Graffity.should_receive(:find).with(:all, hash_including(:limit => 1))
      Wall.get_graffities_for(@wall, :limit => 1)
    end
  end

  describe "#scoped_graffities_for" do
    it "without passing an option should not set an id boundary" do
      Wall.scoped_graffities_for([]).proxy_options.should == {:conditions => []}
    end

    it "passing after option should set a lower limiit" do
      Wall.scoped_graffities_for([], :after => 1).proxy_options.should == {:conditions => ["id > ?", 1]}
    end

    it "passing before option should set a higher limit" do
      Wall.scoped_graffities_for([], :before => 2).proxy_options.should == {:conditions => ["id < ?", 2]}
    end
  end

end