require "rspec"

class Promise
  def initialize(state=:pending)
    @state = state
  end

  def fulfill
    Promise.new(:fulfilled)
  end

  def fulfilled?
    @state == :fulfilled
  end
end

describe "A Promise" do
  context "when pending" do
    it "can be fulfilled" do
      p = Promise.new
      fulfilled = p.fulfill
      expect(fulfilled).to be_fulfilled
    end
  end
end
