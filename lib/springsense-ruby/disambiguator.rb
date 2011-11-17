require File.expand_path('disambiguated_result', File.dirname(__FILE__))

class Disambiguator

  attr_reader :address
  attr_reader :port

  attr_reader :customer_id
  attr_reader :api_key

  def initialize(customer_id, api_key, address, port = 3001)
    @customer_id = customer_id
    @api_key = api_key
    @address = address
    @port = port
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
    params[:api_key] = api_key unless api_key.nil?
    params[:customer_id] = customer_id unless customer_id.nil?
    
    params_s = self.encode_parameters(params)
    
    Net::HTTP.start(@address, @port) do |client|
      client.open_timeout = 120
      client.read_timeout = 120
      client.post("/disambiguate?#{params_s}", text).body
    end
  rescue => e
    raise "Disambiguator #{@address}:#{@port} - Error while disambiguating '#{text}': #{e}"
  end

  def encode_parameters(parameters = {})
    parameters.map do | key, value |
      "#{key.to_s}=#{URI.escape(value.to_s)}"
    end.join('&')
  end

end