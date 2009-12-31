require File.dirname(__FILE__) + '/../test_helper'

class WallTest < ActiveSupport::TestCase
  context "A Wall" do
    should_have_many :graffities
    should_belong_to :profile

    should "be possible create two graffities as roots in the same wall" do
      owner = Factory(:member).profile
      wall = owner.wall

      graffity1 = Factory(:graffity, :profile => owner, :wall => wall)
      graffity2 = Factory(:graffity, :profile => owner, :wall => wall)

      assert_equal 2, owner.wall.graffities.size
      owner.wall.graffities.each do |g|
        assert g.root?        
      end
    end

  end
end
