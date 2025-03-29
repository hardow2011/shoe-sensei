class UserMailer < Devise::Mailer
    default from: email_address_with_name(
      SenderInfo::Accounts.email,
      SenderInfo::Accounts.name
    )
  
    def confirmation_instructions(...)
      super(...)
    end
end