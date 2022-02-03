module WorkflowActions
  class Call
    include WorkflowActionsActionBase

    def execute(workflow_input_args:, action_results:)
      js_executer = JavascriptExecuter.new(workflow_input_args: workflow_input_args,
                                           action_results: action_results)

      case action
      when "http.post"
        request(js_executer) do |uri, body, headers|
          HTTP.post(uri, body: body.to_json, headers: headers)
        end
      when "http.get"
        request(js_executer) do |uri, _body, headers|
          HTTP.get(uri, headers: headers)
        end
      end
    end

    private

    def action
      action_schema["call"]
    end

    def request(js_executer)
      uri = URI.parse(js_executer.eval(args["url"]))
      body = js_executer.eval(args["body"]) || ""
      headers = args["headers"] || {
        "Content-type" => "application/json; charset=UTF-8"
      }

      response = yield(uri, body, headers)

      if (200..299).cover?(response.code.to_i)
        res = result_key.present? ? { result_key.to_sym => JSON.parse(response.body.to_s) } : {}

        ActionResponse.new(nil, res)
      else
        raise "Bad request"
      end
    end
  end
end
