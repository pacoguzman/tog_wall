require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase
  context "A Profile" do
    should_have_one :wall

    context "when created" do
      setup do
        @profile = Factory(:member).profile
      end

      should "have a wall" do
        assert @profile.wall.is_a?(Wall)
        assert !@profile.wall.new_record?
      end
    end

  end
end
