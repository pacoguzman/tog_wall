class WallsController < ApplicationController

  def show
    @page = params[:page] || '1'
    
    @owner = Profile.active.find(params[:profile_id])
    @wall = @owner.wall
    @graffities = @owner.wall.graffities.paginate(:per_page => Tog::Config['tog_wall.wall.pagination_size'], :page => @page)
  end

end