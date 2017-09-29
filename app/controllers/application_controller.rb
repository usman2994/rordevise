class ApplicationController < ActionController::API

  API_KEY = "48a6045e4f23cad2e35c"
  before_action :verify_api_key#, :authenticate

  def verify_api_key
    api_key = request.headers['X-API-KEY']
    if api_key.present? && api_key.eql?(API_KEY)
      puts 'sadsadasdasdsadsad'
    else
      puts'unauthorised'
      render_unauthorized
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    render json: 'Bad credentials API key level', status: :unauthorized
  end
end
