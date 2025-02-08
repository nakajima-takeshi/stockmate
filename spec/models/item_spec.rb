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
      expect(item.errors.full_messages).to include("カテゴリーを入力してください")
    end

    it '名前が空欄' do
      item = build(:item, user: user, name: nil)
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("名前を入力してください")
    end

    it '名前が30文字以上' do
      item = build(:item, user: user, name: "a" * 31)
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("名前は30文字以内で入力してください")
    end

    it '内包量の入力欄が空' do
      item = build(:item, user: user, volume: nil)
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("内包量を入力してください")
    end

    it '内包量の値が0である' do
      item = build(:item, user: user, volume: 0)
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("内包量は0以外の値にしてください")
    end

    it '一週間の使用回数の入力欄が空' do
      item = build(:item, user: user, used_count_per_weekly: nil)
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("一週間の使用回数を入力してください")
    end

    it '一週間の使用回数の値が0である' do
      item = build(:item, user: user, used_count_per_weekly: 0)
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("一週間の使用回数は0以外の値にしてください")
    end

    it '一週間の使用回数の値が全角' do
      item = build(:item, user: user, used_count_per_weekly: "１")
      expect(item).to be_invalid
      expect(item.errors.full_messages).to include("一週間の使用回数は数値で入力してください")
    end
  end
end
