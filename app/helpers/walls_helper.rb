module WallsHelper

  def graffity_created_at_in_words(datetime)
    words = if datetime.utc.today?
      time_ago_in_words(datetime)
    elsif datetime.utc > DateTime.now.utc.yesterday
      I18n.t("wall.datetimes.yesterday_at") + I18n.l(datetime, :format => :yesterday)
    elsif datetime.utc > DateTime.now.utc.ago(1.week)
      I18n.t("wall.datetimes.articulo_el") + I18n.l(datetime, :format => :week)
    else
      I18n.t("wall.datetimes.articulo_el") + I18n.l(datetime, :format => :complete)
    end
  end

  def options_for_collapse
    #TODO set variables to configuration values
    {:selector_for_collapsed => "\'div[id^=collapsed]\'", :collapse_since => 4, :children_showed => 2}
  end

  def options_for_collapse_to_js
    options_for_javascript(options_for_collapse)
  end

  def collapse_replies(graffity, options = {})
    options.reverse_merge!(options_for_collapse)
    content_tag :div, nil, :id => options[:id], :style => "display:none;" do
      link_to I18n.t("tog_wall.views.member.graffities.see_collapsed_comments", :count => graffity.replies.size)
    end if graffity.replies.size > options[:children_showed]
  end

  def icon_loading_flow_pagination(options={})
    options.reverse_merge!(:alt => "Loading")
    image_tag("/tog_wall/images/spinner.gif", options)
  end
end