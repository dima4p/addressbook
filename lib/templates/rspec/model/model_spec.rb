require 'spec_helper'

describe <%= class_name %> do

<% if options[:fixture_replacement] == :factory_girl -%>
  subject { create :<%= singular_name %> }

  it { should be_valid }
<% else -%>
  before :each do
    @valid_attrs = {
    }
  end

  it "should be valid" do
    <%= class_name %>.new(@valid_attrs).should be_valid
  end
<% end -%>

end
