namespace :cleanup do
  desc "clean up unnatached files uploaded during post content editing with tinymce"
  task unnattached_files: :environment do
    ActiveStorage::Blob.unattached.find_each(&:purge_later)
  end
end
