class ApplicationController < ActionController::API
  def authenticate!
    token = request.headers['Authorization']
    if token != ENV['SERVICE_TOKEN']
      return render json: ['Authorization error !'], status: 401
    end
  end
end
