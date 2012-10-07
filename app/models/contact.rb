class Contact < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :middle_name, :phone

  belongs_to :user

  validates :first_name, presence: true
  acts_as_paranoid

end
