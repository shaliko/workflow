class WorkflowInstance < ApplicationRecord
  enum state: { unspecified: 0, active: 1, succeeded: 2, cancelled: 3 }

  belongs_to :workflow
end