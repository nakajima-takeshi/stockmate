require 'rails_helper'

RSpec.describe 'Items', type: :system do
    context '日用品の新規登録画面' do
        it '成功する' do
        end
    end

    context '登録内容の編集画面' do
        it 'カテゴリーを選択されていないため失敗する' do
        end

        it '名前が空欄になっていたため失敗する' do
        end

        it '同じ名前がすでに登録されているため失敗する' do
        end

        it '入力された名前が30文字以上で失敗する' do
        end
    end

    context '登録内容の詳細画面' do
        it '詳細ページにアクセスできる' do
        end
    end

    context '登録内容の削除' do
        it '成功する' do
        end
    end
end
