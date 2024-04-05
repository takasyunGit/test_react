CarrierWave.configure do |config|
  # あとで環境変数に変更する
  config.asset_host = "http://localhost:3010"
  config.storage = :file
  config.cache_storage = :file
end