require_relative './errors'

class Auction
  def initialize(deadline: nil, items: [])
    fail Errors::InvalidDeadlineError unless deadline.is_a?(Time)
    fail Errors::InvalidItemsError unless items.any?

    @deadline = deadline
    @items    = items
    @bidders  = []
  end

  def items
    @items.dup
  end

  def bidders
    @bidders.dup
  end

  def register_bidder(bidder)
    @bidders << bidder
  end

  def finished?
    Time.now > deadline
  end

  private

  attr_reader :deadline
end
