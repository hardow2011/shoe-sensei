namespace :cleanup do
  desc "clean up unatached files uploaded during post content editing with tinymce"
  task unattached_uploads: :environment do
    ActiveStorage::Blob.unattached.where(created_at: ..2.days.ago).find_each(&:purge_later)
  end
end
