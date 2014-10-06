require 'rails_helper'

RSpec.describe BirstSpace, :type => :model do
  before { @birst_space = FactoryGirl.create(:birst_space) }
  subject { @birst_space }

  it { should respond_to(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should respond_to(:client) }
  it { should respond_to(:space_type) }
  it { should respond_to(:space_uuid) }
  it { should be_valid }

  it { should belong_to(:client) }
  
  it { should validate_inclusion_of(:space_type).in_array(BirstSpace::SPACE_TYPES) }

  it { should allow_value('5efddbea-3481-46fd-b7c1-4e04046cefb7').for(:space_uuid) }
  it { should_not allow_value('hefddbea-3481-46fd-b7c1-4e04046cefb7').for(:space_uuid) }
  it { should_not allow_value('my-space').for(:space_uuid) }

  describe 'relationship with client' do
    def duplicate_space_type(space_type)
      existing_space = FactoryGirl.create(:birst_space, space_type: space_type)
      FactoryGirl.build(:birst_space, client: existing_space.client, space_type: space_type)
    end

    BirstSpace::SPACE_TYPES.each do |space_type|
      case space_type
      when 'production', 'staging', 'uat'
        it "only has one #{space_type} space per client" do
          expect(duplicate_space_type(space_type)).not_to be_valid
        end
      else
        it "allows multiple #{space_type} spaces per client" do
          expect(duplicate_space_type(space_type)).to be_valid
        end
      end
    end
  end
end
