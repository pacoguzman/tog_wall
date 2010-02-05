require 'spec_helper'

describe Member::WallsController do

  #should_route :get, "/member/wall", :controller => "member/walls", :action => "show"

  before(:each) do
    @member = Factory(:member)
    @owner = @member.profile
    @wall = @owner.wall
    @graffities = @wall.graffities
    @request.session[:user_id] = @member.id
  end

  describe "show action" do
    before(:each) do
      get :show
    end

    # should_assign_to(:owner) {@owner}
    it "assigns @owner" do
      assigns[:owner].should == @owner
    end

    # should_assign_to(:wall) {@wall}
    it "assigns @wall" do
      assigns[:wall].should == @wall
    end

    # should_assign_to(:graffities) {@graffities}
    it "assigns @graffities" do
      assigns[:graffities].should == @graffities
    end

    # should_respond_with :success
    it "respond with success" do
      response.should be_success
    end

    # should_not_set_the_flash
    it "not set the flash" do
      flash.should be_empty
    end

    # should_render_template 'walls/show'
    it "render template 'walls/show'" do
      response.should render_template('walls/show')
    end
  end
end
  