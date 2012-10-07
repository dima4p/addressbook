require 'spec_helper'

HEADER = "id\tfirst_name\tlast_name\tmiddle_name\tphone\tupdated_at\tdeleted_at"

describe Contact do

  subject { create :contact, user_id: current_user.id }

  it { should be_valid }
  it { should validate_presence_of :user_id }
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
      res.first.should == HEADER
      res = res.last.split(/\t/)
      res.last.should == c2.deleted_at.to_s(:db)
    end

    describe 'responding to :merge_csv' do
      before :each do
        @user = create :active_user
        @c1 = create :contact, user: @user
        @c2 = create :contact, user: @user
        Contact.count.should == 2
        current_user.stub(:to_i) {current_user.id}
      end

      it 'adds new record if no id is set in the file' do
        res = Contact.merge_csv HEADER + "\n\tnew_name\n", @user
        res[:total].should == 1
        res[:created].should == 1
        Contact.count.should == 3
        Contact.last.first_name.should == "new_name"
      end

      it 'reports errors if new record is not valid' do
        res = Contact.merge_csv HEADER + "\n\t\tnew_name\n", @user
        Contact.count.should == 2
        res[:created].should == 0
        res[:errors].should == 1
        res[:messages].should == [["\t\tnew_name\t\t\t\t\n", {:first_name=>["can't be blank"]}]]
      end

      it 'ignores the record if it is not found in the DB' do
        res = Contact.merge_csv HEADER + "\n#{Contact.count + 1}\tnew_name\n", @user
        Contact.count.should == 2
        res[:skipped].should == 1
      end

      it 'ignores the record if timestamp in the DB is newer' do
        res = Contact.merge_csv HEADER + "\n#{@c1.id}\tnew_name\t\t\t\t#{@c1.updated_at - 1.hour}\n", @user
        Contact.count.should == 2
        res[:skipped].should == 1
      end

      it 'ignores the record if the record in the DB is deleted eariler' do
        res = Contact.merge_csv HEADER + "\n#{@c1.id}\tnew_name\t\t\t\t#{@c1.updated_at - 1.hour}\n", @user
        Contact.count.should == 2
        res[:skipped].should == 1
      end

      it 'updates the record if timestamp in the DB is not newer' do
        res = Contact.merge_csv HEADER + "\n#{@c1.id}\tnew_name\t\t\t\t#{@c1.updated_at}\n", @user
        Contact.count.should == 2
        res[:updated].should == 1
        @c1.reload.first_name.should == 'new_name'
      end

      it 'reports errors if timestamp in the DB is not newer but the record has errors' do
        res = Contact.merge_csv HEADER + "\n#{@c1.id}\t\tnew_name\t\t\t#{@c1.updated_at}\n", @user
        Contact.count.should == 2
        res[:errors].should == 1
        res[:messages].first.last.should == {:first_name=>["can't be blank"]}
      end

      it 'undeletes and updates the record if the record in the DB is deleted eariler' do
        @c1.delete
        Contact.count.should == 1
        res = Contact.merge_csv HEADER +
            "\n#{@c1.id}\tnew_name\t\t\t\t#{@c1.updated_at}\t#{@c1.updated_at}\n", @user
        Contact.count.should == 2
        res[:updated].should == 1
        res[:undeleted].should == 1
        Contact.find_by_id(@c1).first_name.should == 'new_name'
      end

      it 'ignores deletion if the record in the DB is updated later' do
        res = Contact.merge_csv HEADER +
            "\n#{@c1.id}\tnew_name\t\t\t\t#{@c1.updated_at}\t#{@c1.updated_at - 1.second}\n", @user
        Contact.count.should == 2
        res[:skipped].should == 1
      end

      it 'deletes the record unless the record in the DB is updated later' do
        res = Contact.merge_csv HEADER +
            "\n#{@c1.id}\tnew_name\t\t\t\t#{@c1.updated_at}\t#{@c1.updated_at}\n", @user
        Contact.count.should == 1
        res[:deleted].should == 1
      end

    end
  end

end
