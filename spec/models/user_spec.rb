require "rails_helper"

RSpec.describe User, type: :model do
    describe 'LINE認証データからユーザーを作成' do
        before do
            # OmniAuthのモックデータを使って、ユーザーを作成
            mock_auth_hash
            @user = User.from_omniauth(auth)
        end
        let(:auth) { OmniAuth.config.mock_auth[:line] }

        context 'ユーザー情報が登録されていない' do
            it 'ユーザー作成' do
                user = @user
                expect(user).to be_persisted # DBに存在しているか
                expect(user.email).to eq('test@example.com')
                expect(user.name).to eq('Test User')
                expect(user.provider).to eq('line')
                expect(user.uid).to eq('12345')
            end
        end

        context 'すでにユーザー情報が登録されている' do
            it '既存のユーザーを取得する' do
                user = @user
                expect(user).to be_persisted
                expect(user).to eq(user)
            end
        end
    end
end
