class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    return can :manage, :all if user.admin?

    can :manage, User, id: user.id
    can :manage, Task, user_id: user.id

    if user.manager?
      can :manage, User do |managed_user|
        managed_user.employee?
      end
    end

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
