class Ability
  include CanCan::Ability

  def initialize(user)
    can([:comment_at_wall, :reply_at_wall], Wall) do |wall|
      wall.present? && user.present? && (user.profile == wall.profile || user.profile.is_friend_of?(wall.profile))
    end

    can([:like_graffity], Graffity) do |graffity|
      unless graffity.present?
        false
      else
        owner = graffity.wall.profile
        user.present? && (user.profile == owner || user.profile.is_friend_of?(owner)) && !graffity.liked_by?(user.profile)
      end
    end

    can([:see_walltowall], Graffity) do |graffity|
      unless graffity.present?
        false
      else
        owner = graffity.wall.profile
        writer = graffity.profile
        user.present? && user.profile.is_friend_of?(owner) && user.profile.is_friend_of?(writer)
      end
    end
  end
end
