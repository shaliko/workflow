module WorkflowActions
  class Switch
    include WorkflowActionsActionBase

    def execute(workflow_input_args:, action_results:)
      js_executer = JavascriptExecuter.new(workflow_input_args: workflow_input_args,
                                           action_results: action_results)

      action.each do |item|
        return ActionResponse.new(item["next"], {}) if js_executer.eval(item["condition"]) == "true"
      end

      ActionResponse.new(default_next, {})
    end

    private

    def action
      action_schema["switch"]
    end
  end
end
