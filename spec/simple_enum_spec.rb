require "spec_helper"
require "rspec/its"

describe SimpleEnum do
  let(:described_class) do
    Class.new do
      include SimpleEnum

      simple_enum status: {
        active: 0,
        inactive: 1
      }

      def initialize(status: nil)
        @status = status
      end
    end
  end
  let(:statuses) do
    {
      active: 0,
      inactive: 1
    }
  end

  describe "class" do
    subject { described_class }

    it { is_expected.to respond_to :simple_enum }
    its(:statuses) { is_expected.to eq statuses }
  end

  describe "instance" do
    let(:described_instance) { described_class.new(status: status) }
    let(:status) { nil }

    subject { described_instance }

    %i(active? active! inactive? inactive!).each do |name|
      it { is_expected.to respond_to name }
    end

    context "initial status is active" do
      let(:status) { described_class.statuses[:active] }

      its(:status) { is_expected.to eq :active }
      its(:active?) { is_expected.to eq true }
      its(:inactive?) { is_expected.to eq false }

      context "`inactive!` has been executed" do
        before do
          described_instance.inactive!
        end

        its(:status) { is_expected.to eq :inactive }
        its(:active?) { is_expected.to eq false }
        its(:inactive?) { is_expected.to eq true }
      end
    end

    context "initial status is inactive" do
      let(:status) { described_class.statuses[:inactive] }

      its(:status) { is_expected.to eq :inactive }
      its(:active?) { is_expected.to eq false }
      its(:inactive?) { is_expected.to eq true }

      context "`inactive!` has been executed" do
        before do
          described_instance.active!
        end

        its(:status) { is_expected.to eq :active }
        its(:active?) { is_expected.to eq true }
        its(:inactive?) { is_expected.to eq false }
      end
    end

    describe "#status=" do
      context "set by integer" do
        before do
          described_instance.status = statuses[:active]
        end

        its(:status) { is_expected.to eq :active }
      end

      context "set by symbol" do
        before do
          described_instance.status = :active
        end

        its(:status) { is_expected.to eq :active }
      end
    end
  end
end
