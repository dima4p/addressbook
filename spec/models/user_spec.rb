require 'spec_helper'

describe User do

  def mock_notifier
    (@notifier ||= mock_model('DummyNotifier').as_null_object).tap do |notifier|
       notifier.stub :deliver => true
    end
  end

  subject { create :user }

  it { should be_valid }

  it 'should respond to :roles=, :roles, :add_role!, and :is?' do
    User.delete_all
    subject.roles.should == ["admin"]
    subject.roles = %w[admin]
    subject.roles.should == %w[admin]
    subject.is?(:admin).should == true
    subject.is?('manager').should == false
    subject.roles = []
    subject.roles.should == []
    subject.add_role!('admin')
    subject.roles.should == %w[admin]
  end

  it 'should respond to :activate!' do
    create :user
    subject.active?.should == false
    subject.activate!
    subject.active?.should == true
  end

  it 'should respond to :deliver_activation_instructions!' do
    Authlogic::Random.stub!(:friendly_token).times.and_return('perishable token')
    Notifier.should_receive(:activation_instructions).with(subject).and_return(mock_notifier)
    subject.deliver_activation_instructions!
    subject.perishable_token.should == 'perishable token'
  end

  it 'should respond to :deliver_welcome!' do
    Authlogic::Random.stub!(:friendly_token).and_return('perishable token')
    Notifier.should_receive(:welcome).with(subject).and_return(mock_notifier)
    subject.deliver_welcome!
    subject.perishable_token.should == 'perishable token'
  end

  it 'should respond to :deliver_password_reset_instructions!' do
    Authlogic::Random.stub!(:friendly_token).and_return('perishable token')
    Notifier.should_receive(:password_reset_instructions).with(subject).and_return(mock_notifier)
    subject.deliver_password_reset_instructions!
    subject.perishable_token.should == 'perishable token'
  end

end
