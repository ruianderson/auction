## Auction Service

On Growing Object-Oriented Software, Guided by Tests (GOOS), the authors introduce
an application that bids automatically on items auctions at an online service.

While the book covers the bidder application and mocks the auction server behavior,
this project tries to implement a real auction server using the aproaches described in the book.

The intention behind it, is to improve OO skills and have a chance to think about
complex problems like: messages integration, transactions, queues, concurrency etc.

## Architecture

The application is composed of two components: Auction & Auction Service.

### Auction

Layer of communication between Bidders and Auction Service. It is an event based
application that resolves the following events:

#### Events triggered by Client:

Event | Description | Data
------|-------------|-----
join  | Joining an auction | `{ auction: AUCTION_ID }`
bid   | Bidding on an auction | `{ token: AUCTION_TOKEN, price: BID_PRICE }`

#### Events triggered by Auction Service

Event | Description | Data
------|-------------|-----
joined | A Client joins | `{ token: AUCTION_TOKEN, round: ROUND_NUMBER }`
price  | A bid was accepted | `{ price: BID_PRICE, bidder: BIDDER_NAME }`
start-round | A new round starts | `{ round: ROUND_NUMBER, price: CURRENT_PRICE }`
close-round | A round closes | `{ round: ROUND_NUMBER }`
close | An auction closes | `{ price: WINNING_PRICE, winner: BIDDER_NAME }`

### Auction Service

- Starts a new auction
- Registers a bidder on an auction
- Starts a round on an auction
- Closes a round on an auction
- Elects a new current winning price on an auction
- Closes an auction
