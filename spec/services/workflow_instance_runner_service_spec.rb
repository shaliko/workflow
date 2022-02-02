require "rails_helper"

RSpec.describe WorkflowInstanceRunnerService do
  let(:arguments) {
    {
      postId: rand(99) + 1,
      userEmail: FFaker::Internet.email,
      userName: FFaker::Internet.user_name,
      comment: FFaker::Lorem.sentence,
    }
  }

  context "when workflow success" do
    let(:workflow_instance) { create(:workflow_instance) }

    it "correct result" do
      described_class.call(workflow_instance: workflow_instance)

      expect(workflow_instance.start_time).to_not be_nil
      expect(workflow_instance.result).to eq("")
    end
  end
end