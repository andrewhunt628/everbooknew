require 'omnicontacts'

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {:redirect_path => '/invitations/gmail/callback'}
end
