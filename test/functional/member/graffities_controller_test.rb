require File.dirname(__FILE__) + '/../../test_helper'

class Member::GraffitiesControllerTest < ActionController::TestCase

  context "A anonymous user" do
    should "denies access to create action" do
      @controller.expects(:create).never
      post :create
    end

    should "denies access to reply action" do
      @controller.expects(:reply).never
      post :reply
    end
  end

  context "A logged User, not a friend of the owner" do
    setup do
      @member = Factory(:member).profile
      @owner = Factory(:member, :login => "Berlusconi").profile
      @request.session[:user_id] = @member.id
      @request.stubs(:referer => "/")
    end

    context "on POST to :create" do
      setup do
        post :create, {:profile_id => @owner.id, :graffity => Factory.attributes_for(:graffity)}
      end

      should "not create a graffity" do
        assert @owner.wall.graffities.empty?
      end

      should "should set a flash error message" do
        assert !flash[:error].empty?
      end
    end

    context "ON POST to :reply" do
      setup do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
        @suplanted_owner = Factory(:member, :login => "Merkel").profile
      end

      context "trying to write a graffity in other wall" do
        setup do
          post :reply, {:profile_id => @suplanted_owner.id, :id => @graffity.id, :graffity => Factory.attributes_for(:graffity)}
        end

        should_render_template("member/site/not_found")

        should "not create any graffity in the owner wall" do
          assert_equal 1, @owner.wall.graffities.size
        end

        should "not create any graffity in the suplanted owner wall" do
          assert @suplanted_owner.wall.graffities.empty?
        end
      end

      context "with correct params" do
        setup do
          post :reply, {:profile_id => @owner.id, :id => @graffity.id, :graffity => Factory.attributes_for(:graffity)}
        end

        should "not create a reply" do
          assert @owner.wall.graffities.first.replys.empty?
        end

        should "set a error flash message" do
          assert !flash[:error].empty?
        end

      end
    end

    
    context "ON POST :like" do
      setup do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
      end

      context "with correct params" do
        setup do
          post :like, {:profile_id => @owner.id, :id => @graffity.id}
        end

        should "not create a like" do
          assert @owner.wall.graffities.first.likes.empty?
        end

        should "set a error flash message" do
          assert !flash[:error].empty?
        end

      end
    end

  end

  
  context "A logged friend user" do
    setup do
      @member = Factory(:member).profile
      @owner = Factory(:member, :login => "Berlusconi").profile
      @request.session[:user_id] = @member.id
      @request.stubs(:referer => "/")

      @owner.add_friend(@member)
    end

    context "ON POST :create" do

      context "with valid graffity params" do
        setup do
          post :create, {:profile_id => @owner.id, :graffity => Factory.attributes_for(:graffity)}
        end

        should "create a graffity in the owner wall" do
          assert_equal 1, @owner.wall.graffities.size
        end

        should "set a ok flash message" do
          assert !flash[:ok].empty?
        end

      end

      context "without comment" do
        setup do
          post :create, {:profile_id => @owner.id, :graffity => {}}
        end

        should "not create a graffity" do
          assert @owner.wall.graffities.empty?
        end

        should "set a error flash message" do
          assert !flash[:error].empty?
        end
      end
    end

    context "ON POST :reply" do
      setup do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
      end

      context "with valid reply params" do
        setup do
          post :reply, {:profile_id => @owner.id, :id => @graffity.id, :graffity => Factory.attributes_for(:graffity)}
        end

        should "create a reply" do
          assert_equal 1, @owner.wall.graffities.first.replys.size
        end

        should "set a ok flash message" do
          assert !flash[:ok].empty?
        end

      end
    end

    context "ON POST :like" do
      setup do
        @graffity = Factory(:graffity, :wall => @owner.wall, :profile => @owner)
      end

      context "with valid params" do
        setup do
          post :like, {:profile_id => @owner.id, :id => @graffity.id}
        end

        should "create a like" do
          assert_equal 1, @owner.wall.graffities.first.likes.size
        end

        should "set a ok flash message" do
          assert !flash[:ok].empty?
        end

      end
    end
  end

end