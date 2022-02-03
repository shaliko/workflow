require "rails_helper"

RSpec.describe WorkflowInstanceRunnerService do
  let(:argument) do
    {
      postId: rand(1..99),
      userEmail: FFaker::Internet.email,
      userName: FFaker::Internet.user_name,
      comment: FFaker::Lorem.sentence
    }
  end

  context "when workflow success" do
    let(:workflow_instance) { create(:workflow_instance, argument: argument) }

    it "correct result" do
      described_class.call(workflow_instance: workflow_instance)

      expect(workflow_instance.start_time).to be_within(30.seconds).of(DateTime.current)

      if (argument[:postId] % 2) == 0
        expect(workflow_instance.result).to start_with("Products count fetched ")
      else
        expect(workflow_instance.result).to eq("Products count 5")
      end
    end
  end
end
