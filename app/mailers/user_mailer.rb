class UserMailer < Devise::Mailer
  layout 'mailer' # use my mailer layour and not Devise's  
  
  default from: email_address_with_name(
      SenderInfo::Accounts.email,
      SenderInfo::Accounts.name
    )
  
    def confirmation_instructions(...)
      super(...)
      @title = I18n.t('user.mailer.confirmation_instructions.welcome')
    end

    def email_changed(...)
      super(...)
      @title = if @resource.try(:unconfirmed_email?)
        I18n.t('user.mailer.email_changed.notify_email_changed', email: @resource.unconfirmed_email)
      else
        I18n.t('user.mailer.email_changed.notify_email_changed', email: @resource.email)
      end
    end

    def password_change(...)
      super(...)
      @title = I18n.t('user.mailer.password_changed.notify_password_changed')
    end

    def reset_password_instructions(...)
      super(...)
      @title = I18n.t('user.mailer.reset_password_instructions.requested_link_to_change_password')
    end
end