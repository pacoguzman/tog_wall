require File.dirname(__FILE__) + '/../test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "Wall abilities" do

    context "without user not logged in" do
      setup do
        @owner = Factory(:member, :login => "ownerious")
        @current_user = nil
        @ability = Ability.new(@current_user)
      end

      should "cannot comment at wall" do
        assert @ability.cannot?(:comment_at_wall, @owner.profile.wall)
      end

      should "cannot reply at wall" do
        assert @ability.cannot?(:reply_at_wall, @owner.profile.wall)
      end

      should "cannot like a graffity" do
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        assert @ability.cannot?(:like_graffity, @graffity)
      end

      should "cannot see walltowall" do
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        assert @ability.cannot?(:see_walltowall, @graffity)
      end
    end

    context "owner" do
      setup do
        @owner = Factory(:member, :login => "ownerious")
        @current_user = @owner
        @ability = Ability.new(@current_user)
      end

      should "can comment at wall that he owns" do
        assert @ability.can?(:comment_at_wall, @owner.profile.wall)
      end

      should "can reply at wall that he owns" do
        assert @ability.can?(:reply_at_wall, @owner.profile.wall)
      end

      should "can like graffity" do
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        assert @ability.can?(:like_graffity, @graffity)
      end

      context "cannot like graffity" do
        setup do
          @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
          @like = Graffity.build_like(@owner.profile.wall, @owner.profile)
          @like.save && @like.move_to_child_of(@graffity)
        end

        should "because you liked it yet" do
          assert @ability.cannot?(:like_graffity, @graffity)
        end
      end
    end

    context "friend of owner" do
      setup do
        @owner = Factory(:user, :login => "ownerious")
        @current_user = @friend = Factory(:user, :login => "friendous")
        @ability = Ability.new(@current_user)

        @owner.profile.add_friend(@current_user.profile)
      end

      should "can comment at wall owned by his friend" do
        assert @ability.can?(:comment_at_wall, @owner.profile.wall)
      end

      should "can reply at wall owned by his friend" do
        assert @ability.can?(:reply_at_wall, @owner.profile.wall)
      end

      context "can like graffity" do
        setup do
          @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        end

        should "because is a friend" do
          assert @ability.can?(:like_graffity, @graffity)
        end
      end
    end

    context "no related member" do
      setup do
        @owner = Factory(:user, :login => "ownerious")
        @current_user = Factory(:user, :login => "norelatious")
        @ability = Ability.new(@current_user)
      end

      should "cannot comment at wall" do
        assert @ability.cannot?(:comment_at_wall, @owner.profile.wall)
      end

      should "cannot reply at wall" do
        assert @ability.cannot?(:reply_at_wall, @owner.profile.wall)
      end

      context "cannot like graffity" do
        setup do
          @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        end

        should "because is not related" do
          assert @ability.cannot?(:like_graffity, @graffity)
        end
      end
    end
  end
end