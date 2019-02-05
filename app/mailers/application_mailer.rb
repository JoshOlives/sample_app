class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  layout 'mailer' #what does this do since its a sender?
end
