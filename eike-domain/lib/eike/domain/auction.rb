require_relative './errors'

class Auction
  attr_reader :current_round, :rounds

  def initialize(deadline: nil, items: [], rounds: nil)
    fail Errors::InvalidDeadlineError unless deadline.is_a?(Time)
    fail Errors::InvalidItemsError unless items.any?
    fail Errors::InvalidRoundsError if rounds.nil? || rounds.zero?

    @deadline       = deadline
    @items          = items
    @bidders  = []
    @rounds         = rounds
    @current_round  = 0
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

  def started?
    !current_round.zero?
  end

  def last_round?
    current_round + 1 > rounds
  end

  def start!
    advance_round!
  end

  def next_round!
    raise Errors::AuctionNotStartedError unless started?
    raise Errors::NoMoreRoundsError if last_round?

    advance_round!
  end

  def finished?
    Time.now > deadline
  end

  private

  attr_reader :deadline

  def advance_round!
    @current_round = @current_round + 1
  end
end
