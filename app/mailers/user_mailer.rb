class UserMailer < Devise::Mailer
    default from: email_address_with_name(
      Rails.application.credentials.dig(:mailgun, Rails.env.to_sym, :senders, :accounts, :email), 
      Rails.application.credentials.dig(:mailgun, Rails.env.to_sym, :senders, :accounts, :name)
    )
  
    def confirmation_instructions(...)
      super(...)
    end
end