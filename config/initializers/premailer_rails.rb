Premailer::Rails.config.merge!(preserve_styles: true, remove_ids: true)
Premailer::Adapter.use = :nokogiri_fast