# Collecting Services Contracts

Collecting Services are a set of contracts that allows users to buy and mint nfts as dues to be paid

For more information visit [Collecting Services 📮](https://www.collecting.services/)

### Supported tokens 💰

-   MATIC
-   USDT
-   USDC
-   DAI

## Testing 🧪

All testing is done using [Polygon Mumbai Testnet](https://mumbai.polygonscan.com/)

<!-- ### Last stable testnet contracts for GOERLI ⚙️

-   [SWAPPER 🔄](https://goerli.etherscan.io/address/0x63676f1Aaad4C5a9443Fb3bd1FEF6611F6A5E84E): 0x63676f1Aaad4C5a9443Fb3bd1FEF6611F6A5E84E
-   [TREASURE 🤑](https://goerli.etherscan.io/address/0x0CDc2A86A61935E4AB920054Fd204a6bB713BDC4): 0x0CDc2A86A61935E4AB920054Fd204a6bB713BDC4 -->

### Contract addresses for Mumbai Testnet ⚙️

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F |
| USDT   | 0x2DB274b9E5946855B83e9Eac5aA6Dcf2c68a95F3 |
| USDC   | 0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747 |

### Contract addresses for POLYGON Mainnet 🟣

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x6B175474E89094C44Da98b954EedeAC495271d0F |
| USDT   | 0xdAC17F958D2ee523a2206206994597C13D831ec7 |
| USDC   | 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 |

### How to use 🤔

1.  Create your own .env file
2.  Add the specified keys to your .env file
3.  Run `yarn install` or `npm install`
4.  Run the following command to compile and deploy the contract:

```shell
npx hardhat compile
npm run deploy:goerli
```

### Environment variables 📝

| Item            |                           Value |
| --------------- | ------------------------------: |
| TESTNET_RPC     |     Add your alchemy RPC server |
| POLYGON_API_KEY | API Key provided by polygonscan |
| PRIVATE_KEY     |         Your wallet private key |
