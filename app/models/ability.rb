class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, UserSession
    can :create, User if not user
    return if not user

    if user.is? :admin
      can :manage, :all
      cannot :manage, Contact
    else
      can [:edit, :show], User, id: user.id
    end
    can :manage, Contact, user_id: user.id

  end
end
