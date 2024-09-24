class Admin::TinymceAssetsController < Admin::AdminController
  protect_from_forgery with: :null_session

  def create
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed

    blob = ActiveStorage::Blob.create_and_upload!(
      io:           params[:file],
      filename:     params[:file].original_filename,
      content_type: params[:file].content_type
    )

    render json: {
        location: url_for(blob)
    }
  end
end
