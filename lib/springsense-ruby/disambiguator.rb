require 'uri'
require 'net/http'

require File.expand_path('disambiguated_result', File.dirname(__FILE__))

class Disambiguator

  attr_reader :app_id
  attr_reader :app_key
  attr_reader :url

  def initialize(app_id, app_key, url)
    @app_id = app_id
    @app_key = app_key
    @url = url
  end

  def disambiguate(text)
    response = call_service(prepare_text(text))

    result = DisambiguatedResult.from_response(response)

    result.text_variants_in_rank_order

    result
  end

  private

  def prepare_text(text)
    text.split(/\n/).join('. ')
  end

  def call_service(text)
    params = {}
    params[:app_key] = app_key unless app_key.nil?
    params[:app_id] = app_id unless app_id.nil?
    params[:body] = text
    
    params_s = encode_parameters(params)
    uri = URI("#{url}?#{params_s}")

    request = Net::HTTP::Get.new(uri.request_uri)
    
    Net::HTTP.start(uri.host, uri.port) do | http |
      http.open_timeout = 120
      http.read_timeout = 120

      response = http.request(request)

      response.body
    end
  rescue => e
    raise "Disambiguator #{url} - Error while disambiguating '#{text}': #{e}"
  end

  def encode_parameters(parameters = {})
    parameters.map do | key, value |
      "#{key.to_s}=#{URI.escape(value.to_s)}"
    end.join('&')
  end

end