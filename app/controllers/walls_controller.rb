class WallsController < ApplicationController
  include WallsHelper
  helper :graffities

  def show
    @owner = Profile.active.find(params[:profile_id])
    @wall = @owner.wall

    @graffities = Wall.get_graffities_for(@wall)
    @last_graffity = @graffities.last

  end

end