Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1758590994357657', '7a7474216b8dddd13d27cc7313f5395e', {:scope => 'user_about_me'}
end