class Maintenance::CleanupUnatachedUploadsJob < ApplicationJob
  queue_as :maintenance

  def perform(*args)
    Rails.application.load_tasks
    Rake::Task["cleanup:unattached_uploads"].execute
  end
end
