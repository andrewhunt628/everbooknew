class ApplicationMailer < ActionMailer::Base
  default :from => "support@kidio.com"

  layout 'mailer'
end
