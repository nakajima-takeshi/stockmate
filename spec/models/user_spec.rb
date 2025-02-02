require "rails_helper"

RSpec.describe User, type: :model do
    describe 'LINE認証データからユーザーを作成' do
        before { mock_auth_hash }
        let(:auth) { OmniAuth.config.mock_auth[:line] }

        it 'ユーザー作成' do
            # OmniAuthのモックデータを使って、ユーザーを作成
            user = User.from_omniauth(auth)

            # ユーザーが正しく作成されているか確認
            expect(user).to be_persisted
            expect(user.email).to eq('test@example.com')
            expect(user.name).to eq('Test User')
            expect(user.provider).to eq('line')
            expect(user.uid).to eq('12345')
        end
    end
end
