require 'spec_helper'

describe Ability do

  describe "Wall abilities" do
    
    describe "a user not logged in" do
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

      it "should cannot see walltowall" do
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @owner.profile)
        @ability.cannot?(:see_walltowall, @graffity).should be_true
      end
    end

    describe "a owner" do
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

        it "because he liked it yet" do
          @ability.cannot?(:like_graffity, @graffity).should be_true
        end
      end
    end

    describe "a friend of the owner" do
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

        it "because is a friend" do
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

        it "because is not related" do
          @ability.cannot?(:like_graffity, @graffity).should be_true
        end
      end
    end

    describe "see wall to wall" do
      it "should cannot if not logged in user" do
        @graffity = Factory.attributes_for(:graffity)
        @ability = Ability.new(@current_user=nil)

        @ability.cannot?(:see_walltowall, @graffity).should be_true
      end

      it "should cannot if not pass a graffity" do
        @current_user = Factory.attributes_for(:member)
        @ability = Ability.new(@current_user=nil)

        @ability.cannot?(:see_walltowall, @graffity=nil).should be_true
      end

      it "should cannot if the writer isn't your friend" do
        @current_user = Factory(:member)
        @writer = Factory(:member, :login => "writer")
        @graffity = Factory(:graffity, :wall => @writer.profile.wall, :profile => @writer.profile)
        @ability = Ability.new(@current_user)

        @ability.cannot?(:see_walltowall, @graffity).should be_true
      end

      it "should cannot if the owner isn't your friend" do
        @current_user = Factory(:member)
        @writer = Factory(:member, :login => "writer")
        @owner = Factory(:member, :login => "owner")
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @writer.profile)
        @ability = Ability.new(@current_user)

        @ability.cannot?(:see_walltowall, @graffity).should be_true
      end

      it "should can if logged in pass a graffity and the writer and the owner are friends of the current user" do
        @current_user = Factory(:member)
        @writer = Factory(:member, :login => "writer")
        @owner = Factory(:member, :login => "owner")
        @current_user.profile.add_friend(@writer.profile)
        @current_user.profile.add_friend(@owner.profile)
        @graffity = Factory(:graffity, :wall => @owner.profile.wall, :profile => @writer.profile)
        @ability = Ability.new(@current_user)

        @ability.can?(:see_walltowall, @graffity).should be_true
      end
    end
  end
end