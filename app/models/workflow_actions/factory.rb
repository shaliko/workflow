module WorkflowActions
  class Factory
    def self.build(action_schema:)
      if action_schema.has_key?("call")
        Call.new(action_schema)
      elsif action_schema.has_key?("switch")
        Switch.new(action_schema)
      elsif action_schema.has_key?("return")
        Return.new(action_schema)
      else
        raise NotImplementedError, "#{self.class} has not implemented factory"
      end
    end
  end
end
