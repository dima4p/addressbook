class Contact < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :middle_name, :phone

  belongs_to :user

  validates :first_name, presence: true
  acts_as_paranoid

  COLUMNS = %w[id first_name last_name middle_name phone updated_at deleted_at]

  class << self
    def to_csv(rel)
      CSV.generate(col_sep: "\t") do |csv|
        csv << COLUMNS
        rel.with_deleted.find_each do |contact|
          csv << COLUMNS.inject([]) do |acc, attr|
            attr = contact.send attr
            acc << (ActiveSupport::TimeWithZone === attr ? attr.to_s(:db) : attr.to_s)
            acc
          end
        end
      end
    end
  end

end
