class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  has_many :items, dependent: :destroy

  # LINEから取得した情報でユーザーを検索または作成
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] # ランダムパスワードを生成
      user.name = auth.info.name
    end
  end

  # LINEからのプロフィール情報を取得
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  # LINE認証で取得した情報をユーザーモデルに設定
  def set_values(omniauth)
    # プロバイダーとuidが一致する場合のみ処理を実行
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    # 保存する認証情報
    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  # LINE APIから取得したユーザー情報を保存
  def set_values_by_raw_info(raw_info)
    # JSON形式で保存
    self.raw_info = raw_info.to_json
    self.save!
  end
end
