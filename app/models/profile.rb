class Profile < ActiveRecord::Base

  after_create :build_wall

  has_one :wall

end
