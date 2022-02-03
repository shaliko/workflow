require 'rails_helper'

RSpec.describe "Api::V1::WorkflowInstances", type: :request do
  describe "POST /run" do
    let(:workflow) { create(:workflow) }

    subject { post "/api/v1/workflow_instances/run", params: params }

    context "when params valid" do
      let(:params) { attributes_for(:workflow_instance).merge({workflow_id: workflow.id}) }

      before do
        Sidekiq::Queue.all.each(&:clear)

        subject
      end

      it { expect(response).to have_http_status(200) }
      it "responds with a valid json object" do
        expect(JSON.parse(response.body)).to eql(JSON.parse(WorkflowInstanceSerializer.new(WorkflowInstance.last).to_json))
      end

      it "enqueues WorkflowInstanceRunnerJob" do
        expect(WorkflowInstanceRunnerJob.jobs.size).to be > 1
      end
    end

    context "when missed argument param" do
      let(:params) { {workflow_id: workflow.id} }

      before { subject }

      it { expect(response).to have_http_status(400) }
    end

    context "when missed workflow_id param" do
      let(:params) { attributes_for(:workflow_instance) }

      before { subject }

      it { expect(response).to have_http_status(404) }
    end
  end
end
