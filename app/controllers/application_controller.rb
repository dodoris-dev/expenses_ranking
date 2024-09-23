class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  def render_not_found
    render json: { error: "Not Found" }, status: :not_found
  end
end
