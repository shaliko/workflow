class ApplicationController < ActionController::API
  def render_bad_request(error_message)
    render status: :bad_request, json: { messages: [error_message].flatten }.to_json
  end
end
