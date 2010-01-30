require 'spec_helper'

describe Ability do

  describe "Wall abilities" do
    
    describe "for user not logged in" do
      before(:each) do
        @owner = Factory(:member, :login => "ownerious")
        @current_user = nil
        @ability = Ability.new(@current_user)
      end

      it "should cannot comment at wall" do
        @ability.cannot?(:comment_at_wall, @owner.profile.wall).should be_true
      end

      it "should cannot reply at wall" do
        @ability.cannot?(:reply_at_wall, @owner.profile.wall).should be_true
      end

      it "should cannot like a graffity" do
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        @ability.cannot?(:like_graffity, @graffity).should be_true
      end
    end

    describe "for owner" do
      before(:each) do
        @owner = Factory(:member, :login => "ownerious")
        @current_user = @owner
        @ability = Ability.new(@current_user)
      end

      it "should can comment at wall that he owns" do
        @ability.can?(:comment_at_wall, @owner.profile.wall).should be_true
      end

      it "should can reply at wall that he owns" do
        @ability.can?(:reply_at_wall, @owner.profile.wall).should be_true
      end

      it "should can like graffity" do
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        @ability.can?(:like_graffity, @graffity).should be_true
      end

      describe "cannot like graffity" do
        before(:each) do
          @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
          @like = Graffity.build_like(@owner.profile.wall, @owner.profile)
          @like.save && @like.move_to_child_of(@graffity)
        end

        it "should because you liked it yet" do
          @ability.cannot?(:like_graffity, @graffity).should be_true
        end
      end
    end

    describe "for a friend of the owner" do
      before(:each) do
        @owner = Factory(:user, :login => "ownerious")
        @current_user = @friend = Factory(:user, :login => "friendous")
        @ability = Ability.new(@current_user)

        @owner.profile.add_friend(@current_user.profile)
      end

      it "should can comment at wall owned by his friend" do
        @ability.can?(:comment_at_wall, @owner.profile.wall).should be_true
      end

      it "should can reply at wall owned by his friend" do
        @ability.can?(:reply_at_wall, @owner.profile.wall).should be_true
      end

      describe "can like graffity" do
        before(:each) do
          @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        end

        it "should because is a friend" do
          @ability.can?(:like_graffity, @graffity).should be_true
        end
      end
    end

    describe "no related member" do
      before(:each) do
        @owner = Factory(:user, :login => "ownerious")
        @current_user = Factory(:user, :login => "norelatious")
        @ability = Ability.new(@current_user)
      end

      it "should cannot comment at wall" do
        @ability.cannot?(:comment_at_wall, @owner.profile.wall).should be_true
      end

      it "should cannot reply at wall" do
        @ability.cannot?(:reply_at_wall, @owner.profile.wall).should be_true
      end

      describe "cannot like graffity" do
        before(:each) do
          @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        end

        it "should because is not related" do
          @ability.cannot?(:like_graffity, @graffity).should be_true
        end
      end
    end
  end
end