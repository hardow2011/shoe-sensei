if Rails.env == 'production'
    # ENV["OPENSEARCH_URL"] = Rails.application.credentials.dig(:aws, :production, :opensearch_url)

    # Searchkick.aws_credentials = {
    #     access_key_id: Rails.application.credentials.dig(:aws, :production, :access_key_id),
    #     secret_access_key: Rails.application.credentials.dig(:aws, :production, :secret_access_key),
    #     region: "us-east-1"
    # }
end