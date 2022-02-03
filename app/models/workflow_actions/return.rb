module WorkflowActions
  class Return
    attr_reader :action

    def initialize(action_schema)
      @action = action_schema["return"]
    end

    def execute(workflow_input_args:, action_results:)
      js_executer = JavascriptExecuter.new(workflow_input_args: workflow_input_args,
                                           action_results: action_results)

      ActionResponse.new(0, js_executer.eval(action))
    end
  end
end
