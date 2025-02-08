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
                select 'シャンプー', from: 'category-select'
                fill_in 'item[name]', with: 'Test_sample'
                fill_in 'item[volume]', with: '300'
                fill_in 'item[used_count_per_weekly]', with: '7'
                fill_in 'item[memo]', with: 'test'
                click_button '登録'
                expect(page).to have_content '新たに日用品を登録しました'
            end
        end

        context '登録内容の編集画面' do
            it 'カテゴリーを選択されていないため失敗する' do
                visit edit_item_path(item)
                select '選択してください', from: 'category-select'
                fill_in 'item[name]', with: 'Test_sample'
                fill_in 'item[volume]', with: '300'
                fill_in 'item[used_count_per_weekly]', with: '7'
                fill_in 'item[memo]', with: 'test'
                click_button '更新'
                expect(page).to have_content 'カテゴリーを選択してください'
            end

            it '名前が空欄になっていたため失敗する' do
                visit edit_item_path(item)
                select 'シャンプー', from: 'category-select'
                fill_in 'item[name]', with: ''
                fill_in 'item[volume]', with: '300'
                fill_in 'item[used_count_per_weekly]', with: '7'
                fill_in 'item[memo]', with: 'test'
                click_button '更新'
                expect(page).to have_content '名前を入力してください'
            end

            it '入力された名前が30文字以上で失敗する' do
                visit edit_item_path(item)
                select 'シャンプー', from: 'category-select'
                fill_in 'item[name]', with: 'a' * 31
                fill_in 'item[volume]', with: '300'
                fill_in 'item[used_count_per_weekly]', with: '7'
                fill_in 'item[memo]', with: 'test'
                click_button '更新'
                expect(page).to have_content '名前は30文字以内で入力してください'
            end
        end

        context '登録内容の削除' do
            it '成功する' do
            end
        end
    end
end
