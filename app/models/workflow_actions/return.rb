module WorkflowActions
  class Return
    include WorkflowActionsActionBase

    def execute(workflow_input_args:, action_results:)
      js_executer = JavascriptExecuter.new(workflow_input_args: workflow_input_args,
                                           action_results: action_results)

      ActionResponse.new(0, js_executer.eval(action))
    end

    private

    def action
      action_schema["return"]
    end
  end
end
