class WorkflowInstanceRunnerJob
  include Sidekiq::Job

  def perform(workflow_instance_runner_id)
    workflow_instance = WorkflowInstance
      .where(start_time: nil).find workflow_instance_runner_id

    WorkflowInstanceRunnerService.call(workflow_instance: workflow_instance)
  end
end
