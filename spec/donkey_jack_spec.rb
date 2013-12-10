require "rspec"

class Promise
  def initialize(state=:pending)
    @state = state
  end

  def fulfill
    return self unless pending?
    Promise.new(:fulfilled)
  end

  def reject
    return self unless pending?
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

  context "when fulfilled" do
    let(:fulfilled) { Promise.new(:fulfilled) }

    it "can't be rejected" do
      promise = fulfilled.reject
      expect(promise).to_not be_rejected
    end
  end

  context "when rejected" do
    let(:rejected) { Promise.new(:rejected) }

    it "can't be fulfilled" do
      promise = rejected.fulfill
      expect(promise).to_not be_fulfilled
    end
  end
end
