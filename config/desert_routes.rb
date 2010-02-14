namespace(:member) do |member|
  member.wall "wall", :controller => "walls", :action => "show"
  member.resources :wall, :only => [], :shallow => true do |wall|
    wall.resources :graffities, :only => [:create, :update, :destroy],
                   :member => {:reply => :post, :like => :get},
                   :collection => {:show_more => :get}
  end
end

profile_wall 'profiles/:profile_id/wall', :controller => "walls", :action => "show", :method => :get
