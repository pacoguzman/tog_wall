class Wall < ActiveRecord::Base

  belongs_to :profile
  has_many :graffities, :conditions => {:parent_id => nil}, :order => 'created_at DESC'

end