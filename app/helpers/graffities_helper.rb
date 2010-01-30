module GraffitiesHelper

  def graffities_paginate_link(*args)
    options = args.extract_options!
    wall_id = params[:wall_id].present? ? params[:wall_id] : current_user.profile.wall.id
    url = show_more_member_wall_graffities_path(wall_id, options[:last_graffity].id)

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