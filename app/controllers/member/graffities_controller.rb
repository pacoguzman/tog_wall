class Member::GraffitiesController < Member::BaseController

  before_filter :load_wall, :only => [:show_more, :create]
  before_filter :load_graffity, :only => [:reply, :like, :update, :destroy]

  def show_more
    @graffities = Wall.get_graffities_for(@wall, :before => params[:id])
    @last_graffity = @graffities.last
  end

  def create
    @graffity = Graffity.build_from(@wall, current_user.profile, params[:graffity], :request => request)

    respond_to do |format|
      if can?(:comment_at_wall,@wall) && @graffity.save
        if @graffity.approved
          flash[:ok] = I18n.t("tog_core.site.comment.added")
        else
          flash[:warning] = I18n.t("tog_core.site.comment.left_pending")
        end
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_commenting")
      end
      format.html { redirect_to request.referer }
      format.js { render :create; flash.discard }
    end
  end

  def reply
    #params[:graffity] is a reply
    @reply = Graffity.build_from(@wall, current_user.profile, params[:graffity], :request => request)

    respond_to do |format|
      if can?(:reply_at_wall, @wall) && @reply.save && @reply.move_to_child_of(@graffity)
        if @reply.approved
          flash[:ok] = I18n.t("tog_core.site.comment.added")
        else
          flash[:warning] = I18n.t("tog_core.site.comment.left_pending")
        end
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_commenting")
      end
      format.html { redirect_to request.referer }
      format.js { render :reply; flash.discard }
    end
  end

  def like
    @like = Graffity.build_like(@wall, current_user.profile, :request => request)

    respond_to do |format|
      if can?(:like_graffity, @graffity) && @like.save && @like.move_to_child_of(@graffity)
        flash[:ok] = I18n.t("tog_core.site.comment.added") # "like added"
        status = :created
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_commenting") # "like error"
        status = :unprocessable_entity
      end
      format.html { redirect_to request.referer }
      format.js { render :like, :status => status; flash.discard }
    end
  end

  def update

  end

  def destroy
    
  end

private
  def load_wall
    @wall = Wall.find(params[:wall_id])
    @owner = Profile.active.find(@wall.profile_id)
  end

  def load_graffity
    @graffity = Graffity.find(params[:id], :include => [:wall])
    @wall = @graffity.wall
    @owner = Profile.active.find(@wall.profile_id)
  end

end