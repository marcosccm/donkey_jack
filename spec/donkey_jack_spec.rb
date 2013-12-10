require "rspec"

class Promise
  attr_reader :value, :reason, :fulfillments, :rejections

  def initialize(state: :pending, value: nil, reason: nil, fulfillments: [], rejections: [])
    @state = state
    @value = value
    @reason = reason
    @fulfillments = fulfillments
    @rejections = rejections
  end

  def then(*callbacks)
    fulfillment, rejection = callbacks
    fulfillments = self.fulfillments + [fulfillment]
    rejections = self.rejections + [rejection]
    Promise.new(state: @state, fulfillments: fulfillments.compact, rejections: rejections.compact)
  end

  def fulfill(value)
    return self unless pending?
    fulfillments.each { |f| f.call(value) }
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

  describe "callbacks can be attached to a promise" do
    let(:promise) { Promise.new }

    it "for when the promise is fulfilled" do
      t = promise.then(-> {})
      expect(t.fulfillments.size).to eq 1
    end

    it "for when the promise is rejected" do
      t = promise.then(nil, -> {})
      expect(t.rejections.size).to eq 1
    end

    it "but they are optional" do
      t = promise.then
      expect(t.fulfillments.size).to eq 0
      expect(t.rejections.size).to eq 0
    end
  end

  describe "a fulfillment callback" do
    it "is called when the promise is fulfilled, with the promise's value as an argument" do
      cb = double
      expect(cb).to receive(:call).with(4)

      p = Promise.new.then(cb).fulfill(4)
    end
  end
end
