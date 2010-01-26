class Profile < ActiveRecord::Base

  before_create :build_wall

  has_one :wall

end
