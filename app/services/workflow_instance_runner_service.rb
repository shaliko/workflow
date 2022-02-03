class WorkflowInstanceRunnerService
  include Callable

  attr_reader :workflow_instance, :steps, :action_results

  def initialize(workflow_instance:)
    @workflow_instance = workflow_instance
    @steps = prepare_steps(workflow_instance)
    @action_results = {}
  end

  def call
    workflow_instance.update!(start_time: DateTime.current)

    workflow_instance.result = run(steps.first[1]) # Run first step
    workflow_instance.end_time = DateTime.current
    workflow_instance.save!
  end

  private

  def run(step)
    action = step[:action]

    rep = action.execute(workflow_input_args: workflow_instance.argument,
                         action_results: action_results)

    # Termination condition
    return rep.result if rep.next_step == 0

    action_results.merge!(rep.result)

    next_step_index = rep.next_step || step[:default_next_step]
    run(steps[next_step_index])
  end

  def prepare_steps(workflow_instance)
    steps = []
    actions = JSON.parse(workflow_instance.workflow.steps)
    keys = actions.keys

    keys.each_with_index do |key, index|
      action_schema = actions[key]
      default_next_step = keys[index + 1] || 0
      action = WorkflowActions::Factory.build(action_schema: action_schema)

      steps << [key,
                {
                  default_next_step: default_next_step,
                  action: action
                }]
    end

    steps.to_h
  end
end
