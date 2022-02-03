require "execjs"

module WorkflowActions
  class Call
    attr_reader :action_type, :args, :result_key

    def initialize(action_schema)
      @action_type = action_schema["call"]
      @result_key = action_schema["result"]
      @args = action_schema["args"]
    end

    def execute(workflow_input_args:, action_results:)
      js_context = ExecJS.compile("var args = #{workflow_input_args.to_json};")

      case action_type
      when "http.post"
        http_post(js_context)
      when "http.get"
        http_get(js_context)
      end
    end

    private

    def http_post(js_context)
      uri = URI.parse(js_eval(args["url"], js_context))
      Rails.logger.debug js_eval(args["url"], js_context).to_yaml
      body = js_eval(args["body"], js_context) || ""
      headers = args["headers"] || {
        "Content-type" => "application/json; charset=UTF-8"
      }

      Rails.logger.debug body.to_json, headers

      response = Net::HTTP.post(uri, body.to_json, headers)

      if (200..299).cover?(response.code.to_i)
        res = result_key.present? ? { result_key.to_sym => response.body } : {}

        # TODO: structure
        { next_step: nil, result: res }
      else
        raise "Bad request"
      end
    end

    def http_get(js_context)
      uri = URI.parse(js_eval(args["url"], js_context))
      headers = args["headers"] || {
        "Content-type": "application/json; charset=UTF-8"
      }

      Rails.logger.debug uri.to_yaml

      response = Net::HTTP.get_response(uri, headers)

      if (200..299).cover?(response.code.to_i)
        res = result_key.present? ? { result_key.to_sym => response.body } : {}

        Rails.logger.debug res.to_yaml
        # TODO: structure
        { next_step: nil, result: res }
      else
        raise "Bad request"
      end
    end

    def js_eval(value, js_context)
      case value
      when Hash
        value.each do |k, v|
          value[k] = v.gsub(/(\$\{)(.+?)(\})/) { |_| js_context.eval(Regexp.last_match(2)).to_s }
        end
      when String
        value.gsub(/(\$\{)(.+?)(\})/) { |_| js_context.eval(Regexp.last_match(2)).to_s }
      else
        value
      end
    end
  end
end
