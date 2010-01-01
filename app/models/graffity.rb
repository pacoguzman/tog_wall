class Graffity < ActiveRecord::Base

  acts_as_nested_set :dependent => :destroy

  belongs_to :wall
  belongs_to :profile

  has_many :replys, :class_name => "Graffity", :foreign_key => "parent_id", :conditions => {:type_common => true}, :order => "created_at ASC"
  has_many :likes, :class_name => "Graffity", :foreign_key => "parent_id", :conditions => {:type_common => false}
  named_scope :type_likes, {:conditions => {:type_common => false}}

  validates_presence_of :comment, :if => :is_common_graffity?

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
    c = self.new
    c.wall = wall
    c.profile = profile
    c.title = graffity[:title]
    c.comment = graffity[:comment]
    c.type_common = graffity[:type_common].nil? ? true : graffity[:type_common]

    c.approved = !wall.respond_to?("moderated") || !wall.moderated || wall.profile_id = profile_id
    c.spam = Cerberus.check_spam(c, params[:request])

    c
  end

  def self.build_like(wall, profile, params = {})
    self.build_from(wall, profile, {:type_common => false}, params)
  end

  def is_common_graffity?
    type_common
  end

  def is_like_graffity?
    !type_common
  end

  def liked_by?(profile)
    likes.exists?(["profile_id = ?", profile.id])
  end
end
