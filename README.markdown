Tog Wall
========

Tog wall management

Included functionality
-----------------------

* Comment in a wall
* Reply comments in a wall
* Like comments
* Flow pagination
* Collapse replies

Resources
=========

Gem requirements
----------------

* http://github.com/collectiveidea/awesome_nested_set/
* http://github.com/ryanb/cancan/

Install
-------

* Install plugin form source:

<pre>
ruby script/plugin install git://github.com:pacoguzman/tog_wall.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_wall
</pre>

	  with the following content:

<pre>
class InstallTogWall < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_wall", 3
  end

  def self.down
    migrate_plugin "tog_wall", 0
  end
end
</pre>

* Add tog_wall's routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_wall'
</pre>

* And finally...

<pre>
rake db:migrate
</pre>

* Run the test with

<pre>
rake tog:plugins:test PLUGIN=tog_wall
</pre>

TODO
-------

* Show people like some graffity/comment
* Add flow_pagination support using an actually flow_pagination instead will_paginate
* Make possible to run the specs
* Add examples of cucumber features with mundopepino or not
* Better styling
* Version using jQuery instead Prototype for the javascript behaviour
* Create an wall-to-wall with other user as facebook does
* In your wall (friends + you or friends or you)


More
-------

[http://github.com/pacoguzman/tog_wall](http://github.com/pacoguzman/tog_wall)

[http://github.com/pacoguzman/tog_wall/wikis](http://github.com/pacoguzman/tog_wall/wikis)


Copyright (c) Paco Guzman, released under the MIT license
