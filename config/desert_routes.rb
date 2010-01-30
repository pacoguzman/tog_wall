namespace(:member) do |member|
  member.wall "wall", :controller => "walls", :action => "show"
  member.resource :wall, :only => [], :path_prefix => 'member/profiles/:profile_id', :name_prefix => 'member_profile_' do |wall|
    wall.resources :graffities, :only => [:create, :update, :destroy], :member => {:reply => :post, :like => :get}
    wall.show_more 'graffities/:id/show_more.:format', :controller => 'graffities', :action => 'show_more', :method => :get
  end
end

resource :wall, :path_prefix => 'profiles/:profile_id', :name_prefix => 'profile_', :only => [:show]
