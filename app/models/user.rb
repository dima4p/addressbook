class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :roles

  acts_as_authentic do |config|
    config.merge_validates_length_of_password_field_options:minimum => 8
    config.login_field :email
  end # block optional

  after_create :set_admin_for_first

  ROLES = %w[admin]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def add_role!(role)
    self.roles = (roles << role.to_s)
    save
  end

  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.welcome(self).deliver
    # logger.debug "User@#{__LINE__}#deliver_welcome! #{self.inspect}"
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver
  end

  private

  def set_admin_for_first
    if User.limit(2).count == 1
      self.roles = ['admin']
      self.active = true
      save
    end
  end

end
