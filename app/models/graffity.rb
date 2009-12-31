class Graffity < ActiveRecord::Base

  acts_as_nested_set :dependent => :destroy

  belongs_to :wall
  belongs_to :profile

  has_many :replys, :class_name => "Graffity", :foreign_key => "parent_id", :order => "created_at ASC"

  validates_presence_of :comment

  def self.build_from(wall, profile, graffity, params = {})
    c = self.new
    c.wall = wall
    c.profile = profile
    c.title = graffity[:title]
    c.comment = graffity[:comment]

    c.approved = !wall.respond_to?("moderated") || !wall.moderated || wall.profile_id = profile_id
    c.spam = Cerberus.check_spam(c, params[:request])

    c
  end

  unless Tog::Plugins.settings(:tog_conversatio, 'search.skip_indices')
    define_index do
      indexes :title
      indexes :comment

      has :approved
      has :spam
    end

    def self.site_search(query, search_options={})
      self.search(query, search_options.merge(:with => {:approved => true, :spam => false}))
    end
  end

end