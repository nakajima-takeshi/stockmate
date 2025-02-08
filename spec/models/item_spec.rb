require 'rails_helper'

RSpec.describe Item, type: :model do
  before { @item = FactoryBot.create(:item) }
end
