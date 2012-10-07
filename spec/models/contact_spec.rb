require 'spec_helper'

describe Contact do

  subject { create :contact }

  it { should be_valid }
  it { should validate_presence_of :first_name }

  describe :class do
    it 'should respond to :to_csv' do
      user = create :active_user
      c1 = create :contact, user: user
      c2 = create :contact, user: user
      c2 = c2.delete
      c2 = Contact.only_deleted.last
      res = Contact.to_csv(Contact.order(:id))
      res.should be_a_kind_of String
      res = res.split(/\n/)
      res.first.should == "id\tfirst_name\tlast_name\tmiddle_name\tphone\tupdated_at\tdeleted_at"
      res = res.last.split(/\t/)
      res.last.should == c2.deleted_at.to_s(:db)
    end
  end

end
