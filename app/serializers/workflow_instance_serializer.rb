class WorkflowInstanceSerializer < ActiveModel::Serializer
  attributes :id, :argument, :error, :result, :start_time, :end_time, :state, :current_step
end