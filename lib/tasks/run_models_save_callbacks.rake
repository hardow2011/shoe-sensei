task run_models_save_callbacks: :environment do
  Model.all.each { |m| m.save }
end
