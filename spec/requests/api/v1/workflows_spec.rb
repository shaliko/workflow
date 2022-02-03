require 'rails_helper'

RSpec.describe "Api::V1::Workflows", type: :request do
  describe "POST /create" do
    subject { post "/api/v1/workflows", params: params }

    context "when params valid" do
      let(:params) { attributes_for(:workflow) }

      before { subject }

      it { expect(response).to have_http_status(200) }
      it "responds with a valid json object" do
        expect(response.body).to eql(WorkflowSerializer.new(Workflow.last).to_json)
      end
    end

    context "when missed name param" do
      let(:params) { attributes_for(:workflow).slice(:steps) }

      before { subject }

      it { expect(response).to have_http_status(400) }
    end

    context "when missed steps param" do
      let(:params) { attributes_for(:workflow).slice(:name) }

      before { subject }

      it { expect(response).to have_http_status(400) }
    end
  end
end
