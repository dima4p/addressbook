require 'spec_helper'

describe Contact do

  subject { create :contact }

  it { should be_valid }
  it { should validate_presence_of :first_name }

end
