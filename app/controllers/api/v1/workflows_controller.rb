module Api
  module V1
    class WorkflowsController < ApplicationController
      def index
        render json: Workflow.order(id: :desc).page(params[:page]), serializer: WorkflowSerializer
      end

      def show
        render json: Workflow.find(params[:id]), serializer: WorkflowSerializer
      end

      def create
        workflow = Workflow.new(create_params)
        if workflow.save
          render json: workflow, serializer: WorkflowSerializer
        else
          render_bad_request(workflow.errors.full_messages)
        end
      end

      private

      def create_params
        params.require(:name)
        params.require(:steps)
        params.permit(:name, :steps)
      end
    end
  end
end
