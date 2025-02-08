require 'rails_helper'

RSpec.describe 'Items', type: :system do
    before do
        line_login
    end

    let(:auth) { OmniAuth.config.mock_auth[:line] }
    let!(:user) { User.from_omniauth(auth) }
    let!(:item) { create(:item, user: user) }

    describe '日用品の新規登録画面' do
        context '正常な入力' do
            it '成功する' do
                visit new_item_path
                select 'shampoo', from: 'category-select'
                fill_in 'item[name]', with: 'Test_sample'
                fill_in 'item[volume]', with: '300'
                fill_in 'item[used_count_per_weekly]', with: '7'
                fill_in 'item[memo]', with: 'test'
                click_button '登録'
                expect(page).to have_content '新たに日用品を登録しました'
            end
        end
    end
end
