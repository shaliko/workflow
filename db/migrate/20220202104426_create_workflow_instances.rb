class CreateWorkflowInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_instances do |t|
      t.belongs_to :workflow, null: false
      t.json :argument
      t.json :error
      t.string :result
      t.datetime :start_time
      t.datetime :end_time
      t.integer :state, limit: 1, default: 0
      t.string :current_step

      t.timestamps
    end
  end
end

# WorkflowInstance
# - workflow_id: integer
# - argument: json
# - error: json
# - result: string
# - startTime: DateTime
# - endTime: DateTime
# - state: STATE_UNSPECIFIED, ACTIVE, SUCCEEDED, FAILED, CANCELLED
# - current_step: string
