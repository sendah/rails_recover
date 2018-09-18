require 'rails_helper'
describe Listing do
  context '登録' do
    user_id = FactoryGirl.create(:user).user_id
      listing = Listing.new(
        home_type: 1,
        pet_type: 2,
        pet_size: 3,
        breeding_years: 4
        user_id: user_id
      )
      expect(listing).to be_valid
      listing.save

      latest_listing = Listing.order('listing_id DESC').limit(1)
      expect(latest_listing.home_type).to eq(1)
      expect(latest_listing.pet_type).to eq(2)
      expect(latest_listing.pet_size).to eq(3)
      expect(latest_listing.breeding_years).to eq(4)
  end
  context 'バリデーション' do
    let(:user) do
      FactoryGirl.create(:user)
    end
    it 'お家の種類は必須である' do
      listing = FactoryGirl.build(:listing, user_id: user.user_id, home_type: nil)
      expect(listing).not_to be_valid
    end
    it 'ペットの種類は必須である' do
      llisting = FactoryGirl.build(:listing, user_id: user.user_id, pet_type: nil)
      expect(listing).not_to be_valid
    end
    it 'ペットのサイズは必須である' do
      llisting = FactoryGirl.build(:listing, user_id: user.user_id, pet_size: nil)
      expect(listing).not_to be_valid
    end
    it 'ペットの飼育歴は必須である' do
      llisting = FactoryGirl.build(:listing, user_id: user.user_id, breeding_years: nil)
      expect(listing).not_to be_valid
    end
  end
end