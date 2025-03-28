class UserMailer < Devise::Mailer
    # default from: "noreply@yourdomain.com"
  
    def confirmation_instructions(...)
      super(...)
    end
end