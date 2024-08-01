require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  setup do
    # This is to generate the cached_tags on saving the models through the task
    Rails.application.load_tasks
    Rake::Task['run_models_save_callbacks'].invoke
  end
end
