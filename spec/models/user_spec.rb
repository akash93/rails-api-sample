require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }
  it { should be_valid }

  describe 'response' do 
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
  end

  describe 'validation' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive}
    it { should validate_confirmation_of(:password) }
    it { should allow_value('user@example.com').for(:email) }
  end

end
