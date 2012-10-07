require 'spec_helper'

describe "contacts/import.html.haml" do
  it "renders import contact form" do
    controller.stub!(:can?).and_return(true)
    render

    assert_select "form", :action => contacts_path, :method => "post" do
      assert_select "input#csv_name[name=?]", "csv[name]"
    end
  end
end
