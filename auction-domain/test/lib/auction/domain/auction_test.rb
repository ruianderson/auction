require 'test_helper'
require 'auction/domain/auction'
require 'auction/domain/item'

describe Auction do
  it 'requires a deadline' do
    proc { Auction.new }.must_raise Errors::InvalidDeadlineError
  end

  it 'requires a list of items' do
    proc { Auction.new(deadline: Time.new(2015, 01, 01)) }.must_raise Errors::EmptyAuctionItemsError
  end

  describe '#items' do
    it 'returns an immutable list of auction\'s items' do
      auction = Auction.new(deadline: Time.new(2015, 01, 01), items: [Item.new('name', 1.0)])

      auction.items.clear
      auction.items.wont_be_empty
    end
  end

  describe '#finished?' do
    let(:deadline) { Time.new(2015, 01, 01) }
    let(:auction) { Auction.new(deadline: deadline, items: [Item.new('name', 1.0)]) }

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
