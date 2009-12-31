namespace(:member) do |member|
  member.resource :wall, :only => [], :path_prefix => 'profiles/:profile_id', :name_prefix => 'member_profile_' do |wall|
    wall.resources :graffities, :only => [:create, :update, :destroy], :member => {:reply => :post}
  end
end

resource :wall, :path_prefix => 'profiles/:profile_id', :name_prefix => 'profile_', :only => [:show]