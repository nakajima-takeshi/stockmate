require 'rails_helper'

RSpec.describe 'Users', type: :system do
    before { mock_auth_hash }

    describe 'ユーザーログイン' do
        it 'LINE連携ログインボタンからログインできる' do
            visit root_path
            click_button 'LINE登録から始める'
            expect(page).to have_content 'ログインしました'
            expect(current_path).to eq items_path
        end
    end
end
