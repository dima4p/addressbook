class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation, :roles, :name, :picture_url

  acts_as_authentic do |config|
    config.login_field :email
    config.validate_email_field = false
    config.validate_password_field = false
  end

  validates :password,
      presence: { if: :password_required? },
      length: { minimum: 8, if: :password_required? },
      confirmation: true
  validates :email,
      presence: { if: :email_available?},
      uniqueness: true,
      confirmation: true

  after_create :set_admin_for_first

  ROLES = %w[admin]

  class << self

    def find_or_create_from_oauth(auth_hash)
      provider = auth_hash["provider"]
      uid = auth_hash["uid"]
      case provider
        when 'facebook'
          if user = find_by_email(auth_hash["info"]["email"])
            user.send(:update_user_from_facebook, auth_hash)
            return user
          elsif user = find_by_facebook_uid(uid)
            return user
          else
            return create_user_from_facebook(auth_hash)
          end
        when 'twitter'
          if user = find_by_twitter_uid(uid)
            return user
          else
            return create_user_from_twitter(auth_hash)
          end
      end
    end

    def create_user_from_facebook(auth_hash)
      user = new(name: auth_hash["info"]["name"],
                 picture_url: auth_hash["info"]["image"],
                 email: auth_hash["info"]["email"])
      user.facebook_uid = auth_hash["uid"]
      user.crypted_password = user.password_salt = user.persistence_token = 'facebook'
      user.save
    end

    def create_user_from_twitter(auth_hash)
      user = new(name: auth_hash["info"]["name"],
                 picture_url: auth_hash["info"]["image"])
      user.twitter_uid = auth_hash["uid"]
      user.crypted_password = user.password_salt = user.persistence_token = 'twitter'
      user.save
    end

  end   # class << self


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

  def image
    picture_url || "http://placehold.it/48x48"
  end

  private

  def set_admin_for_first
    if User.limit(2).count == 1
      self.roles = ['admin']
      self.active = true
      save
    end
  end

  def password_required?
    facebook_uid.blank?
    #facebook_uid.blank? && twitter_uid.blank?
  end

  def email_available?
    true
    #twitter_uid.blank?
  end

  def update_user_from_facebook(auth_hash)
    self.facebook_uid = auth_hash["uid"]
    self.picture_url = auth_hash["info"]["image"] if picture_url.blank?
    save
  end

end
