module SenderInfo
    class Accounts
        def self.email
            Rails.application.credentials.dig(:mailgun, Rails.env.to_sym, :senders, :accounts, :email)
        end
        def self.name
            Rails.application.credentials.dig(:mailgun, Rails.env.to_sym, :senders, :accounts, :name)
        end
    end
end
