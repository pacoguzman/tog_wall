require File.dirname(__FILE__) + '/../test_helper'

class WallsControllerTest < ActionController::TestCase

  should_route :get, "/profiles/1/wall", :controller => "walls", :action => "show", :profile_id => "1"

  context "The walls controller" do
    setup do
      @user = Factory(:member)
      @owner = @user.profile
      @wall = @owner.wall
      @graffities = @wall.graffities

      context "show action" do
        setup do
          get :show, {:profile_id => @owner.id}
        end

        should_assign_to(:owner) {@owner}
        should_assign_to(:wall) {@wall}
        should_assign_to(:graffities) {@graffities}

        should_respond_with :success

        should_not_set_the_flash

        should_render_template :show
      end
    end
  end
end