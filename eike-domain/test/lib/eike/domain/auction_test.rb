require 'test_helper'
require 'eike/domain/auction'
require 'eike/domain/item'
require 'eike/domain/bidder'

describe Auction do
  it 'requires a deadline' do
    proc { Auction.new(deadline: nil) }.must_raise Errors::InvalidDeadlineError
  end

  it 'requires a list of items' do
    proc { Auction.new(deadline: Time.new(2015, 01, 01)) }.must_raise Errors::InvalidItemsError
  end

  it 'requires a number of rounds greater than 0' do
    proc { Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 0) }.must_raise Errors::InvalidRoundsError
  end

  describe '#items' do
    it 'returns an immutable list of auction\'s items' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      auction.items.clear
      auction.items.wont_be_empty
      auction.items.each { |item| item.must_be_kind_of(Item) }
    end
  end

  describe '#register_bidder' do
    it 'registers a given bidder on auction' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      bidder = Bidder.new(name: 'Bidder #01')
      auction.register_bidder(bidder)

      auction.bidders.must_include(bidder)
    end
  end

  describe '#started?' do
    it 'returns true when auction has started' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      auction.start!
      auction.started?.must_equal true
    end

    it 'returns false when auction didn\'t started' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      auction.started?.must_equal false
    end
  end

  describe '#last_round?' do
    it 'returns true when reached the number of rounds' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      auction.start!
      auction.last_round?.must_equal true
    end

    it 'returns false when didn\'t reached the number of rounds' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 2)

      auction.start!
      auction.last_round?.must_equal false
    end
  end

  describe '#start!' do
    it 'starts the auction on round 1' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      auction.start!
      auction.current_round.must_equal 1
    end
  end

  describe '#next_round!' do
    it 'requires the auction to be started' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      proc { auction.next_round! }.must_raise Errors::AuctionNotStartedError

    end

    it 'changes the current round to the next one' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 2)

      auction.start!
      auction.next_round!

      auction.current_round.must_equal 2
    end

    it 'doesn\'t allows to advance if the numbers of rounds is reached' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)], rounds: 1)

      auction.start!

      proc { auction.next_round! }.must_raise Errors::NoMoreRoundsError
    end
  end

  describe '#finished?' do
    let(:deadline) { Time.new(2015, 01, 01) }
    let(:auction) { Auction.new(deadline: deadline, items: [Item.new('name', 1.0)], rounds: 1) }

    describe 'when current time is not past due auction\'s deadline' do
      it 'indicates that auction is still running' do
        Time.stub :now, Time.new(2014, 12, 29) do
          auction.finished?.must_equal false
        end

        Time.stub :now, deadline do
          auction.finished?.must_equal false
        end
      end
    end

    describe 'when current time is past due auction\'s deadline' do
      it 'indicates that auction is no longer running' do
        Time.stub :now, Time.new(2015, 01, 20) do
          auction.finished?.must_equal true
        end
      end
    end
  end
end
