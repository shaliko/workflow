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

    it "save correct results" do
      described_class.call(workflow_instance: workflow_instance)

      expect(workflow_instance.start_time).to be_within(30.seconds).of(DateTime.current)
      expect(workflow_instance.end_time).to be_within(2.seconds).of(DateTime.current)

      if (argument[:postId] % 2) == 0
        expect(workflow_instance.result).to start_with("Products count fetched ")
        expect(workflow_instance.current_step).to eq("evenPostIdReturn")
      else
        expect(workflow_instance.result).to eq("Products count 5")
        expect(workflow_instance.current_step).to eq("returnOutput")
      end
    end
  end

  context "when workflow failed with raise exception" do
    let(:workflow_instance) { create(:workflow_instance, argument: nil) }

    it "saves error log" do
      described_class.call(workflow_instance: workflow_instance)

      expect(workflow_instance.error).to be_eql({"message"=>"TypeError: Cannot read property 'postId' of null"})

      expect(workflow_instance.start_time).to be_within(30.seconds).of(DateTime.current)
      expect(workflow_instance.end_time).to be_within(2.seconds).of(DateTime.current)
    end
  end
end
