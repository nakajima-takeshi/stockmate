require "rails_helper"

RSpec.describe User, type: :model do
    describe 'LINE認証データからユーザーを作成' do
        before do
            mock_auth_hash
        end
        let(:auth) { OmniAuth.config.mock_auth[:line] }

        context 'ユーザー情報が登録されていない' do
            let(:user) { User.from_omniauth(auth) }
            it 'ユーザー新規登録する' do
                expect(user).to be_persisted
                expect(user.email).to eq('test@example.com')
                expect(user.name).to eq('Test User')
                expect(user.provider).to eq('line')
                expect(user.uid).to eq('12345')
            end
        end

        context 'すでにユーザー情報が登録されている' do
            it '既存のユーザーを取得する' do
                first_user = User.from_omniauth(auth)
                second_user = User.from_omniauth(auth)
                expect(first_user).to eq(second_user)
            end
        end
    end
end
