require_plugin 'tog_core'
require_plugin 'tog_user'
require_plugin 'tog_social'
require_plugin 'restful_authentication'

Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Plugins.settings :tog_wall,  'wall.pagination_size' => 10
Tog::Plugins.settings :tog_wall,  'search.skip_indices' => false

Tog::Plugins.helpers WallsHelper

Tog::Search.sources << "Graffity"

#Tog::Interface.sections(:admin).add "Users", "/admin/users"
#Tog::Interface.sections(:member).add "My account", "/member/account"