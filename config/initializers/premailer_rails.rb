Premailer::Rails.config.merge!(remove_ids: true)
Premailer::Adapter.use = :nokogiri