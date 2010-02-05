require 'spec_helper'

describe WallsController do

  #should_route :get, "/profiles/1/wall", :controller => "walls", :action => "show", :profile_id => "1"

  before(:each) do
    @user = Factory(:member)
    @owner = @user.profile
    @wall = @owner.wall
    @graffities = @wall.graffities
  end

  describe "show action" do
    before(:each) do
      get :show, {:profile_id => @owner.id}
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

    # should_render_template :show
    it "render template show" do
      response.should render_template('walls/show')
    end

  end  
end