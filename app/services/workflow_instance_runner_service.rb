class WorkflowInstanceRunnerService
  include Callable

  attr_reader :workflow_instance, :steps

  def initialize(workflow_instance:)
    @workflow_instance = workflow_instance
    @steps = prepare_steps(workflow_instance)
  end

  def call
    workflow_instance.update!(start_time: DateTime.current)

    workflow_instance.result = self.run
    workflow_instance.end_time = DateTime.current
    workflow_instance.save!
  end

  private

  def run

    # WorkflowActionFactory
  end

  def prepare_steps(workflow_instance)
    steps = []
    actions = JSON.parse(workflow_instance.workflow.steps)
    keys = actions.keys

    keys.each_with_index do |key, index|
      action_schema = actions[key]
      default_next_step = keys[index + 1] || 0
      action = WorkflowActions::Factory.build(workflow_input_args: workflow_instance.argument,
                                              action_schema: action_schema)

      steps << [ key,
        {
          default_next_step: default_next_step,
          action: action,
        }
      ]
    end

    # puts steps.to_h.to_yaml

    steps.to_h
  end
end

# Task
#

# if (json.call.present)
# t = Task.new(CallTask.new(json, defaultNext)) -> Factory


# # WorkflowInstance
# currentStepIndex = 0
# results = {
#   'job': {}
# }
# steps = [{1}, {2}, {3}, {4}, {5}, ...]
#
# {1}.run => {
#   next_step: 'name' || 0 || nil,
#   result: {'name': value},
# }
#
# # // Tree / Composite
#
# currentStepName: 'step1'
# {
#   'step1': RubyClass.new(arguments, 23234, defaultNext: 'step2'),
#   'step2': RubyClass.new(arguments, 23234, defaultNext: 'step2'),
#   'step3': RubyClass.new(arguments, 23234, defaultNext: 0),
# }.each {||}

# Worker
# wi = WorkflowInstance.find 111
# wi.run
