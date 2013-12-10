require "rspec"

class Promise
  def initialize(state=:pending)
    @state = state
  end

  def fulfill
    Promise.new(:fulfilled)
  end

  def reject
    Promise.new(:rejected)
  end

  def fulfilled?
    @state == :fulfilled
  end

  def rejected?
    @state == :rejected
  end

  def pending?
    @state == :pending
  end
end

describe "A Promise" do
  context "when pending" do
    let(:promise) { Promise.new }

    it "is marked as pending" do
      expect(promise).to be_pending
    end

    it "can be rejected" do
      rejected = promise.reject
      expect(rejected).to be_rejected
    end

    it "can be fulfilled" do
      fulfilled = promise.fulfill
      expect(fulfilled).to be_fulfilled
    end
  end
end
