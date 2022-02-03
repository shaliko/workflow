module WorkflowActions
  class Switch
    attr_reader :action, :args, :result_key, :default_next

    def initialize(action_schema)
      @action = action_schema["switch"]
      @result_key = action_schema["result"]
      @args = action_schema["args"]
      @default_next = action_schema["next"]
    end

    def execute(workflow_input_args:, action_results:)
      js_executer = JavascriptExecuter.new(workflow_input_args: workflow_input_args,
                                           action_results: action_results)

      for item in action do
        if js_executer.eval(item["condition"]) == 'true'
          return ActionResponse.new(item["next"], {})
        end
      end

      ActionResponse.new(default_next, {})
    end
  end
end
