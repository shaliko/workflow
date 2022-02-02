module WorkflowActions
  class Factory
    def self.build(workflow_input_args:, action_schema:)
      if action_schema.has_key?('call')
        Call.new(workflow_input_args, action_schema)
      elsif action_schema.has_key?('switch')
        Switch.new(workflow_input_args, action_schema)
      elsif action_schema.has_key?('return')
        Return.new(workflow_input_args, action_schema)
      else
        raise NotImplementedError, "#{self.class} has not implemented factory"
      end
    end
  end
end