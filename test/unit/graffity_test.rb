require File.dirname(__FILE__) + '/../test_helper'

class GraffityTest < ActiveSupport::TestCase
  context "A Graffity" do
    should_belong_to :wall
    should_belong_to :profile
    should_have_many :replys

    should "not be valid without a comment" do
      owner = Factory(:member, :login => "ownerious")
      visitor = Factory(:member, :login => "visitorious")

      graffity = Graffity.new(:wall => owner.profile.wall, :profile => visitor.profile)
      assert !graffity.valid?
    end

  end
end