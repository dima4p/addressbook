class Contact < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :middle_name, :phone

  belongs_to :user

  validates :first_name, :user_id, presence: true
  acts_as_paranoid

  COLUMNS = %w[id first_name last_name middle_name phone updated_at deleted_at]
  CSV_OPTIONS = {col_sep: "\t"}

  class << self

    def to_csv(rel)
      CSV.generate(CSV_OPTIONS) do |csv|
        csv << COLUMNS
        rel.with_deleted.find_each do |contact|
          csv << COLUMNS.inject([]) do |acc, attr|
            attr = contact.send attr
            acc << (ActiveSupport::TimeWithZone === attr ? attr.to_s(:db) : attr.to_s)
            acc
          end
        end
      end
    end     # to_csv

    def merge_csv(string, user)
      total = created = updated = undeleted = deleted = skipped = errors = 0
      messages = []
      logger.debug "Contact@#{__LINE__}.merge_csv #{string.inspect}" if logger.debug?
      parsed = CSV.parse(string, CSV_OPTIONS.merge(headers: true))
      total = parsed.size
      parsed.each do |csv_record|
        logger.debug "Contact@#{__LINE__}.merge_csv #{csv_record.to_hash.inspect}" if logger.debug?
        if (id = csv_record['id']).nil?
          record = create csv_record.to_hash.merge(user_id: user), without_protection: true
          logger.debug "Contact@#{__LINE__}.merge_csv #{record.inspect}" if logger.debug?
          if record.valid?
            created += 1
          else
            errors += 1
            messages << [csv_record.to_csv(col_sep: "\t"), record.errors.messages]
          end
        else
          record = with_deleted.find_by_id id
          if record.nil?
            skipped += 1
          else
            logger.debug "Contact@#{__LINE__}.merge_csv #{csv_record['updated_at'].to_time.inspect} #{record.updated_at.inspect}" if logger.debug?
            if csv_record['deleted_at'].present? and dlt = csv_record['deleted_at'].to_time and
                record.deleted_at.blank?
              if record.updated_at.to_s(:db).to_time > dlt
                skipped += 1
              else
                record.delete
                deleted += 1
              end
            elsif (upd = csv_record['updated_at'].to_time) >= record.updated_at.to_s(:db).to_time and
                (record.deleted_at.nil? or upd >= (dlt = record.deleted_at.to_s(:db).to_time))
              record.update_attributes csv_record.to_hash.merge(deleted_at: nil), without_protection: true
              if record.valid?
                updated += 1
                undeleted += 1 if dlt
              else
                errors += 1
                messages << [csv_record.to_csv(col_sep: "\t"), record.errors.messages]
              end
            else
              skipped += 1
            end
          end
        end
      end
      {total: total, created: created, updated: updated, deleted: deleted, undeleted: undeleted,  skipped: skipped, errors: errors, messages: messages}
    end     # merge_csv

  end   # class << self

end
