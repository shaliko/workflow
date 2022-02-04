require "active_support/concern"

module WorkflowActionsActionBase
  extend ActiveSupport::Concern

  included do
    attr_reader :action_schema

    def initialize(action_schema)
      @action_schema = action_schema
    end

    def result_key
      action_schema["result"]
    end

    def args
      action_schema["args"]
    end

    def default_next
      action_schema["next"]
    end
  end
end
