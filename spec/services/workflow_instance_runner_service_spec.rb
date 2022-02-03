require "rails_helper"

RSpec.describe WorkflowInstanceRunnerService do
  let(:arguments) do
    {
      postId: rand(1..99),
      userEmail: FFaker::Internet.email,
      userName: FFaker::Internet.user_name,
      comment: FFaker::Lorem.sentence
    }
  end

  context "when workflow success" do
    let(:workflow_instance) { create(:workflow_instance, argument: arguments) }

    it "correct result" do
      described_class.call(workflow_instance: workflow_instance)

      expect(workflow_instance.start_time).to be_within(2.seconds).of(DateTime.current)
      expect(workflow_instance.result).to eq("")
    end
  end
end
