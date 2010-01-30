namespace(:member) do |member|
  member.wall "wall", :controller => "walls", :action => "show"
  member.resources :wall, :only => [], :shallow => true do |wall|
    wall.resources :graffities, :only => [:create, :update, :destroy],
                   :member => {:reply => :post, :like => :get},
                   :collection => {:show_more => :get}
  end
end

resource :wall, :path_prefix => 'profiles/:profile_id', :name_prefix => 'profile_', :only => [:show]
