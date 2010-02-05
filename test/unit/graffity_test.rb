require File.dirname(__FILE__) + '/../test_helper'

class GraffityTest < ActiveSupport::TestCase
  context "A Graffity" do
    setup do
      @owner = Factory(:member, :login => "ownerious")
      @member = Factory(:member, :login => "visitorious")
    end

    should_belong_to :wall
    should_belong_to :profile
    should_have_many :replies

    should_have_many :likes
    should_have_named_scope :type_likes

    should_validate_presence_of :wall
    should_validate_presence_of :profile

    context "common comment" do
      should "not be valid without a comment" do
        graffity = Graffity.new(:wall => @owner.profile.wall, :profile => @member.profile)
        assert !graffity.valid?
      end
      should "be valid without passing type_common but with a comment" do
        graffity = Factory.build(:graffity, :wall => @owner.profile.wall, :profile => @member.profile)
        assert graffity.valid?
      end
    end

    context "like comment" do
      should "be valid without a comment" do
        graffity = Graffity.new(:type_common => false, :wall => @owner.profile.wall, :profile => @member.profile)
        assert graffity.valid?
      end
    end

    context "#build_like" do
      should "build a like graffity" do
        assert Graffity.build_like(@owner.profile.wall, @owner.profile).is_like_graffity?
      end
    end

  end
end