ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Remove test files after integration tests
    # https://guides.rubyonrails.org/active_storage_overview.html#integration-tests
    # TODO: if this is uncommented, test:all (not test nor test:system) will receive a file not found error.
    # Fix later?
    # parallelize_teardown do |i|
    #   FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test_fixtures).root)
    # end
  end
end
