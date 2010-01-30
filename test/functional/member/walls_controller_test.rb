require File.dirname(__FILE__) + '/../../test_helper'

class Member::WallsControllerTest < ActionController::TestCase

  should_route :get, "/member/wall", :controller => "member/walls", :action => "show"

  context "The member walls controller" do
    setup do
      @user = Factory(:member)
      @owner = @user.profile
      @wall = @owner.wall
      @graffities = @wall.graffities
      @request.session[:user_id] = @member.id

      context "show action" do
        setup do
          get :show
        end

        should_assign_to(:owner) {@owner}
        should_assign_to(:wall) {@wall}
        should_assign_to(:graffities) {@graffities}

        should_respond_with :success

        should_not_set_the_flash

        should_render_template 'walls/show'
      end
    end
  end
end