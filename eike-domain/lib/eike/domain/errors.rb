module Errors
  class InvalidDeadlineError < ArgumentError; end
  class InvalidItemsError < ArgumentError; end
  class InvalidRoundsError < ArgumentError; end
  class AuctionNotStartedError < ArgumentError; end
  class NoMoreRoundsError < ArgumentError; end
end
