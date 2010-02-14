class WallsController < ApplicationController
  include WallsHelper
  helper :graffities

  before_filter :to_id_required, :only => [:walltowall]

  def show
    @owner = Profile.active.find(params[:profile_id])
    @wall = @owner.wall

    @graffities = Wall.get_graffities_for(@wall)
    @last_graffity = @graffities.last
  end

  def walltowall
    @from = Profile.active.find(params[:profile_id])
    @graffities = Wall.get_walltowall_graffities_for([@from, @to])
    @last_graffity = @graffities.last
  end

  protected
  def to_id_required
    @to = Profile.active.find(params[:to_id])
  end

end