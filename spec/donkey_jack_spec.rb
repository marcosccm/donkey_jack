require "rspec"

class Promise
  attr_reader :value, :reason

  def initialize(state: :pending, value: nil, reason: nil)
    @state = state
    @value = value
    @reason = reason
  end

  def fulfill(value)
    return self unless pending?
    Promise.new(state: :fulfilled, value: value)
  end

  def reject(reason)
    return self unless pending?
    Promise.new(state: :rejected, reason: reason)
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
      rejected = promise.reject("some reason")
      expect(rejected).to be_rejected
    end

    it "can be fulfilled" do
      fulfilled = promise.fulfill("some value")
      expect(fulfilled).to be_fulfilled
    end
  end

  context "when fulfilled" do
    it "has a value" do
      promise = Promise.new
      fulfilled = promise.fulfill(4)
      expect(fulfilled.value).to eq 4
    end

    it "can't be rejected" do
      promise = Promise.new(state: :fulfilled).reject("some reason")
      expect(promise).to_not be_rejected
    end
  end

  context "when rejected" do
    it "has a reason" do
      promise = Promise.new
      rejected = promise.reject("fail")
      expect(rejected.reason).to eq "fail"
    end

    it "can't be fulfilled" do
      promise = Promise.new(state: :rejected).fulfill("some value")
      expect(promise).to_not be_fulfilled
    end
  end
end
