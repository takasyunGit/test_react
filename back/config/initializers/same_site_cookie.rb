# クッキーにsame site属性をつけるための設定
# gem 'rails_same_site_cookie'と同時に使用
# rails 6.1以降は以下の設定がないとsamesite Noneの属性がcookieに付与されない
Rails.application.configure do
  config.action_dispatch.cookies_same_site_protection = nil
end
