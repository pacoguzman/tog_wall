class Graffity < ActiveRecord::Base

  acts_as_nested_set :dependent => :destroy

  belongs_to :wall
  belongs_to :profile

  has_many :replies, :class_name => "Graffity", :foreign_key => "parent_id", :conditions => {:type_common => true}, :order => "created_at ASC"
  has_many :likes, :class_name => "Graffity", :foreign_key => "parent_id", :conditions => {:type_common => false}
  named_scope :type_likes, {:conditions => {:type_common => false}}
  named_scope :in_walls, lambda {|*walls|
    {:conditions => { :wall_id => Array(*walls).collect(&:id) }}
  }
  named_scope :in_profiles, lambda {|*profiles|
    {:conditions => { :profile_id => Array(*profiles).collect(&:id) }}
  }

  validates_presence_of :comment, :if => :common_graffity?
  validates_presence_of :wall
  validates_presence_of :profile

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

  def self.build_from(wall, profile, graffity, params = {})
    g = self.new
    g.wall = wall
    g.profile = profile
    g.title = graffity[:title]
    g.comment = graffity[:comment]
    g.type_common = graffity[:type_common].nil? ? true : graffity[:type_common]

    g.approved = !wall.respond_to?("moderated") || !wall.moderated || wall.profile_id == profile_id
    g.spam = Cerberus.check_spam(g, params[:request])

    g
  end

  def self.build_like(wall, profile, params = {})
    self.build_from(wall, profile, {:type_common => false}, params)
  end

  def common_graffity?
    type_common
  end

  def like_graffity?
    !type_common
  end

  def liked_by?(profile)
    likes.exists?(["profile_id = ?", profile.id])
  end
end
