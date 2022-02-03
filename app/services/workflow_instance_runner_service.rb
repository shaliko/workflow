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

    first_step_key, _ = steps.first
    workflow_instance.result = run(first_step_key)
    workflow_instance.end_time = DateTime.current
    workflow_instance.save!
  end

  private

  def run(step_key)
    puts "Running step: #{step_key}"

    step = steps[step_key]

    workflow_instance.update(current_step: step_key)

    rep = step[:action].execute(workflow_input_args: workflow_instance.argument,
                         action_results: action_results)

    # Termination condition
    return rep.result if rep.next_step == 0

    action_results.merge!(rep.result)

    next_step_key = rep.next_step || step[:default_next_step]

    run(next_step_key)
  rescue Exception => error
    workflow_instance.error = { message: error.message }
  end

  def prepare_steps(workflow_instance)
    steps = []
    actions = JSON.parse(workflow_instance.workflow.steps)
    keys = actions.keys

    keys.each_with_index do |key, index|
      default_next_step = keys[index + 1] || 0
      action = WorkflowActions::Factory.build(action_schema: actions[key])

      steps << [key,
                {
                  default_next_step: default_next_step,
                  action: action
                }]
    end

    steps.to_h
  end
end
