require 'rails_helper'
describe User do 
it 'is not be valid without name' do
user = User.new(name: '')
expect(user).not_to be_valid
end
end