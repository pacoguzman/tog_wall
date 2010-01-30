class Wall < ActiveRecord::Base

  belongs_to :profile
  has_many :graffities, :conditions => {:parent_id => nil}, :order => 'created_at DESC'

  def self.get_graffities_for(walls, *args)
    options = args.extract_options!
    scoped_graffities_for(walls, options).
            all(:order => 'id DESC',
                :limit => options[:limit] || Tog::Config['plugins.tog_wall.wall.pagination_size'])
  end

  def self.get_walltowall_graffities_for(profiles, *args)
    options = args.extract_options!
    walls = Array(profiles).collect(&:wall)
    scoped_graffities_for(walls, options).
            in_profiles(profiles).
            all(:order => 'id DESC',
                :limit => options[:limit] || Tog::Config['plugins.tog_wall.wall.pagination_size'])
  end

  def self.scoped_graffities_for(walls, *args)
    options = args.extract_options!

    if options[:before].present?
      conditions = ["id < ?", options[:before] ]
    elsif options[:after].present?
      conditions = ["id > ?", options[:after] ]
    else
      conditions = []
    end

    Graffity.scoped(:conditions => {:parent_id => nil}).
            in_walls(walls).scoped(:conditions => conditions)
  end

end