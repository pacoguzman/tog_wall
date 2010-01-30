class Member::WallsController < Member::BaseController

  include WallsHelper
  helper :graffities

  def show
    @owner = current_user.profile
    @wall = @owner.wall

    @graffities = Wall.get_graffities_for(@wall)
    @last_graffity = @graffities.last

    render "walls/show"
  end
  
end