class Ability
  include CanCan::Ability

  def initialize(user)
    can [:comment_at_wall, :reply_at_wall], Wall do |wall|
      wall && (user.profile == wall.profile || user.profile.is_friend_of?(wall.profile))
    end

    can [:like_graffity], Graffity do |graffity|
      owner = graffity.wall.profile
      graffity && (user.profile == owner || user.profile.is_friend_of?(owner)) && !graffity.liked_by?(user.profile)
    end
  end
end
