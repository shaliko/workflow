class WorkflowSerializer < ActiveModel::Serializer
  attributes :id, :name, :steps
end