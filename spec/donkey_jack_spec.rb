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
end

describe "A Promise" do
  context "when pending" do
    it "can be rejected" do
      p = Promise.new
      rejected = p.reject
      expect(rejected).to be_rejected
    end

    it "can be fulfilled" do
      p = Promise.new
      fulfilled = p.fulfill
      expect(fulfilled).to be_fulfilled
    end
  end
end
