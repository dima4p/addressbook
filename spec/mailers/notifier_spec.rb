require "spec_helper"
require "email_spec"

describe Notifier do
  include RSpec::Mocks::ExampleMethods
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  before (:each) do
    mock_user({
      :name => 'New user',
      :email => "users@email.info",
      :perishable_token => 'pcode'
    })
    I18n.locale = :en
  end

  describe 'activation_instructions' do
    before (:each) do
      ActionMailer::Base.default_url_options = {:host => 'core.info'}
      @email = Notifier.activation_instructions mock_user
    end

    subject { @email }

    it "should be delivered to the user's email" do
      should deliver_to("users@email.info")
    end

    it "should be delivered from dima@koulikoff.ru" do
      should deliver_from("dima@koulikoff.ru")
    end

    it { should have_subject("Address Book: Activation Instructions") }

    it "should have activation link" do
      should have_body_text("http://core.info/activate/pcode")
    end

  end

  describe 'welcome' do
    before (:each) do
      ActionMailer::Base.default_url_options = {:host => 'core.info'}
      @email = Notifier.welcome mock_user
    end

    subject { @email }

    it "should be delivered to the user's email" do
      should deliver_to("users@email.info")
    end

    it "should be delivered from dima@koulikoff.ru" do
      should deliver_from("dima@koulikoff.ru")
    end

    it { should have_subject("Address Book: Welcome!") }

    it "should have link to the application" do
      should have_body_text("#{root_url :host => 'core.info'}")
    end

  end

end
