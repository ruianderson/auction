require_relative './errors'

class Auction
  def initialize(deadline: deadline, items: [])
    fail Errors::InvalidDeadlineError unless deadline.is_a?(Time)
    fail Errors::EmptyAuctionItemsError unless items.any?

    @deadline = deadline
    @items    = items
  end

  def items
    @items.dup
  end

  def finished?
    Time.now > deadline
  end

  private

  attr_reader :deadline
end
