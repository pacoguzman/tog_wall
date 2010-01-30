module GraffitiesHelper

  def graffities_paginate_link(*args)
    options = args.extract_options!
    profile_id = params[:profile_id].present? ? params[:profile_id] : current_user.profile.id
    url = member_profile_wall_show_more_path(profile_id, options[:last_graffity].id)

    link_to content_tag(:span, t('tog_wall.views.walls.show.show_more.button')),
            url, :class => 'graffity_paginate_link button',
                 :id => 'graffity_paginate_link'
    #TODO set loading code
    #:loading => activities_paginate_loading
  end

  def graffities_paginate_loading
    update_page do |page|
      page['graffity_paginate_link'].hide
      page['graffity_paginate_loading'].show
    end
  end

  def show_more_button(graffities)
    if graffities.size == Tog::Config['plugins.tog_wall.wall.pagination_size'].to_i
      render '/member/graffities/show_more'
    end
  end
end