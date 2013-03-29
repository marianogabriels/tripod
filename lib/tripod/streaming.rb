require 'net/http'

module Tripod
  module Streaming

    # stream data from a url
    # opts
    #  :accept => "*/*"
    #  :timeout_seconds = 10
    #  :limit_bytes = nil
    def self.get_data(request_url, opts={})

      accept = opts[:accept] || "*/*"
      timeout_in_seconds = opts[:timeout_seconds] || 10
      limit_in_bytes = opts[:response_limit_bytes]

      uri = URI(request_url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = timeout_in_seconds

      total_bytes = 0
      response_string = ""

      begin
        http.request_get(uri.request_uri, 'Accept' => accept) do |res|
          Rails.logger.debug "TRIPOD: response code: #{res.code}" if defined?(Rails)
          raise Tripod::Errors::BadSparqlRequest.new(res.body) if res.code.to_s != "200"

          res.read_body do |seg|
            total_bytes += seg.size
            response_string += seg.to_s
            # if there's a limit, stop when we reach it
            raise Tripod::Errors::SparqlResponseTooLarge.new if limit_in_bytes && (total_bytes > limit_in_bytes)
          end
        end
      rescue Timeout::Error => timeout
        raise Tripod::Errors::Timeout.new
      end

      response_string

    end

  end
end