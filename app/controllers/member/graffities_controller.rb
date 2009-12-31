class Member::GraffitiesController < Member::BaseController

  before_filter :load_wall
  before_filter :load_graffity_to_reply, :only => [:reply]

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
      #format.js { render :create; flash.discard }
    end
  end

  def reply
    #params[:graffity] is a reply
    @reply = Graffity.build_from(@wall, current_user.profile, params[:graffity], :request => request)

    respond_to do |format|
      if @graffity.wall_id == @wall.id && can?(:reply_at_wall,@wall) && @reply.save && @reply.move_to_child_of(@graffity)
        if @reply.approved
          flash[:ok] = I18n.t("tog_core.site.comment.added")
        else
          flash[:warning] = I18n.t("tog_core.site.comment.left_pending")
        end
      else
        flash[:error] = I18n.t("tog_core.site.comment.error_commenting")
      end
      format.html { redirect_to request.referer }
      #format.js { render :reply; flash.discard }
    end
  end

  def update

  end

  def destroy
    
  end

private
  def load_wall
    @owner = Profile.active.find(params[:profile_id])
    @wall = @owner.wall
  end

  def load_graffity_to_reply
    @graffity = Graffity.find(params[:id])
  end

end