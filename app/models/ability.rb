class Ability
  include CanCan::Ability

  def initialize(user)

    can :manage, UserSession
    can :create, User if user.new_record?
    return if user.new_record?

    if user.is? :admin
      can :manage, :all
    else
      can [:edit, :show], User, id: user.id
    end

  end
end
