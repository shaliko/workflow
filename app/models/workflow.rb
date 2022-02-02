class Workflow < ApplicationRecord
  has_many :workflow_instances, dependent: :destroy

  validates :name, :steps, presence: true
end
