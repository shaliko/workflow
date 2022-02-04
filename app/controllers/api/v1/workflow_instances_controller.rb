module Api
  module V1
    class WorkflowInstancesController < ApplicationController
      before_action :find_workflow, only: :run

      def index
        render json: WorkflowInstance.order(id: :desc).page(params[:page]), serializer: WorkflowInstanceSerializer
      end

      def show
        render json: WorkflowInstance.find(params[:id]), serializer: WorkflowInstanceSerializer
      end

      def run
        workflow_instance = @workflow.workflow_instances.build(run_params)

        if workflow_instance.save
          WorkflowInstanceRunnerJob.perform_async(workflow_instance.id)
          render json: workflow_instance, serializer: WorkflowInstanceSerializer
        else
          render_bad_request(workflow_instance.errors.full_messages)
        end
      end

      private

      def find_workflow
        @workflow = Workflow.find(params[:workflow_id])
      end

      def run_params
        params.require(:argument)
        params.permit(argument: {})
      end
    end
  end
end
