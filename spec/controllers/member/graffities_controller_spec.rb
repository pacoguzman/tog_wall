require 'spec_helper'

describe Member::GraffitiesController do

  context "A anonymous user" do
    it "denies access to create action" do
      @controller.expects(:create).never
      post :create, {:wall_id => 1}
    end

    it "denies access to reply action" do
      @controller.expects(:reply).never
      post :reply, {:wall_id => 1}
    end

    it "denies access to like action" do
      @controller.expects(:like).never
      post :like, {:wall_id => 1}
    end

    it "denies access to update action" do
      @controller.expects(:update).never
      put :reply, {:wall_id => 1}
    end
    
    it "denies access to destroy action" do
      @controller.expects(:destroy).never
      delete :reply, {:wall_id => 1}
    end
  end

  context "A logged User, not a friend of the owner" do
    before(:each) do
      @member = Factory(:member).profile
      @owner = Factory(:member, :login => "Berlusconi").profile
      @request.session[:user_id] = @member.id
      @request.stubs(:referer => "/")
    end

    context "on POST to :create" do
      before(:each) do
        post :create, {:wall_id => @owner.wall.id, :graffity => Factory.attributes_for(:graffity)}
      end

      it "not create a graffity" do
        @owner.wall.graffities.should be_empty
      end

      it "set a flash error message" do
        flash[:error].should_not be_empty
      end
    end

    context "ON POST to :reply" do
      before(:each) do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
        @suplanted_owner = Factory(:member, :login => "Merkel").profile
      end

      context "trying to write a graffity in other wall" do
        before(:each) do
          post :reply, {:id => @graffity.id, :graffity => Factory.attributes_for(:graffity)}
        end

        it "not create any graffity in the owner wall" do
          @owner.wall.should have(1).graffity
        end

        it "not create any graffity in the suplanted owner wall" do
          @suplanted_owner.wall.graffities.should be_empty
        end
      end

      context "with correct params" do
        before(:each) do
          post :reply, {:id => @graffity.id, :graffity => Factory.attributes_for(:graffity)}
        end

        it "not create a reply" do
          @graffity.reload.replies.should be_empty
        end

        it "set a error flash message" do
          flash[:error].should_not be_empty
        end

      end
    end

    context "ON GET :like" do
      before(:each) do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
      end

      context "with correct params" do
        before(:each) do
          get :like, {:id => @graffity.id}
        end

        it "not create a like" do
          @graffity.reload.likes.should be_empty
        end

        it "set a error flash message" do
          flash[:error].should_not be_empty
        end
      end
    end

  end


  context "A logged friend user" do
    before(:each) do
      @member = Factory(:member).profile
      @owner = Factory(:member, :login => "Berlusconi").profile
      @request.session[:user_id] = @member.id
      @request.stubs(:referer => "/")

      @owner.add_friend(@member)
    end

    context "ON POST :create" do

      context "with valid graffity params" do
        before(:each) do
          post :create, {:wall_id => @owner.wall.id, :graffity => Factory.attributes_for(:graffity)}
        end

        it "create a graffity in the owner wall" do
          @owner.wall.should have(1).graffities
        end

        it "set a ok flash message" do
          flash[:ok].should_not be_empty
        end
      end

      context "without comment" do
        before(:each) do
          post :create, {:wall_id => @owner.wall.id, :graffity => {}}
        end

        it "not create a graffity" do
          @owner.wall.should have(0).graffities
        end

        it "set a error flash message" do
          flash[:error].should_not be_empty
        end
      end
    end

    context "ON POST :reply" do
      before(:each) do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
      end

      context "with valid reply params" do
        before(:each) do
          post :reply, {:id => @graffity.id, :graffity => Factory.attributes_for(:graffity)}
        end

        it "create a reply" do
          @owner.wall.graffities.first.should have(1).replies
        end

        it "set a ok flash message" do
          flash[:ok].should_not be_empty
        end
      end
    end

    context "ON GET :like" do
      before(:each) do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
      end

      context "with valid params" do
        before(:each) do
          get :like, {:id => @graffity.id}
        end

        it "create a like" do
          @owner.wall.graffities.first.should have(1).like
        end

        it "set a ok flash message" do
          flash[:ok].should_not be_empty
        end
      end
    end
  end

end