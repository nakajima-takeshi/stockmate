require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    mock_auth_hash
  end

  describe 'バリデーションチェック' do
    let(:auth) { OmniAuth.config.mock_auth[:line] }
    let!(:user) { User.from_omniauth(auth) }

    it '設定したすべてのバリデーションが機能しているか' do
      item = build(:item, user: user)
      expect(item).to be_valid
      expect(item.errors).to be_empty
    end

    it 'カテゴリーが選択されていない' do
      item = build(:item, user: user, category: nil)
      expect(item).to be_invalid
      expect(item.errors[:category]).to include("を入力してください")
    end

    it '名前が空欄' do
      item = build(:item, user: user, name: nil)
      expect(item).to be_invalid
      expect(item.errors[:name]).to include("を入力してください")
    end

    it '名前が30文字以上' do
      item = build(:item, user: user, name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
      expect(item).to be_invalid
      expect(item.errors[:name]).to include("は30文字以内で入力してください")
    end

    it '内包量が空欄' do
      item = build(:item, user: user, volume: nil)
      expect(item).to be_invalid
      expect(item.errors[:volume]).to include("を入力してください")
    end

    it '内包量が0である' do
      item = build(:item, user: user, volume: 0)
      expect(item).to be_invalid
      expect(item.errors[:volume]).to include("は0以外の値にしてください")
    end

    it '一週間の使用回数が空欄' do
      item = build(:item, user: user, used_count_per_weekly: nil)
      expect(item).to be_invalid
      expect(item.errors[:used_count_per_weekly]).to include("を入力してください")
    end

    it '一週間の使用回数が0である' do
      item = build(:item, user: user, used_count_per_weekly: 0)
      expect(item).to be_invalid
      expect(item.errors[:used_count_per_weekly]).to include("は0以外の値にしてください")
    end

    it '一週間の使用回数が全角文字' do
      item = build(:item, user: user, used_count_per_weekly: "１")
      expect(item).to be_invalid
      expect(item.errors[:used_count_per_weekly]).to include("は数値で入力してください")
    end
  end
end
