class Ability
  include CanCan::Ability

  def initialize(user)
    can([:comment_at_wall, :reply_at_wall], Wall) do |wall|
      wall && user && (user.profile == wall.profile || user.profile.is_friend_of?(wall.profile))
    end

    can([:like_graffity], Graffity) do |graffity|
      owner = graffity.wall.profile
      graffity && user && (user.profile == owner || user.profile.is_friend_of?(owner)) && !graffity.liked_by?(user.profile)
    end

    can([:see_walltowall], Graffity) do |graffity|
      owner = graffity.wall.profile
      writer = graffity.profile
      graffity && user && user.profile.is_friend_of?(owner) && user.profile.is_friend_of?(writer)
    end
  end
end
