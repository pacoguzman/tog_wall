class Profile < ActiveRecord::Base

  after_create :create_wall

  has_one :wall

private
  def create_wall
    self.wall = Wall.new
  end

end