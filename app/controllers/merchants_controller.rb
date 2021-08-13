require 'rack/multipart'

class MerchantsController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user!

  def create
    env = {
      'CONTENT_TYPE' => request.headers['Content-Type'],
      'CONTENT_LENGTH' => request.body.length,
      'rack.input' => StringIO.new(request.body.read)
    }

    data = Rack::Multipart.parse_multipart(env)

    render json: read_parsed_multipart(data)
  end

  def index
  end

  private
    def read_parsed_multipart(data)
      data['file'][:tempfile].read
    end
end
