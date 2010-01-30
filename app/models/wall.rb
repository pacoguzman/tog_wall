class Wall < ActiveRecord::Base

  belongs_to :profile
  has_many :graffities, :conditions => {:parent_id => nil}, :order => 'created_at DESC'

  def self.get_graffities_for(walls, *args)
    options = args.extract_options!

    if options[:before].present?
      conditions = ["parent_id IS NULL AND wall_id IN (?) AND id < ?", Array(walls).collect{ |w| w.id }, options[:before] ]
    elsif options[:after].present?
      conditions = ["parent_id IS NULL AND wall_id IN (?) AND id > ?", Array(walls).collect{ |w| w.id }, options[:after] ]
    else
      conditions = ["parent_id IS NULL AND wall_id IN (?)", Array(walls).collect{ |w| w.id } ]
    end

    Graffity.find(:all, :conditions => conditions,
                        :order => 'id DESC',
                        :limit => options[:limit] || Tog::Config['plugins.tog_wall.wall.pagination_size'])
  end

end