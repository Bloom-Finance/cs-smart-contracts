# Collecting Services Contracts

Collecting Services are a set of contracts that allows users to buy and mint nfts as dues to be paid

For more information visit [Collecting Services 📮](https://www.collecting.services/)

### Supported tokens 💰

-   MATIC
-   USDT
-   USDC
-   DAI

## Testing 🧪

All testing is done using [Polygon Mumbai Testnet 🔮](https://mumbai.polygonscan.com/)

### Last stable testnet contracts for Mumbai ⚙️

-   [NFTReceipts 🎨](https://mumbai.polygonscan.com/address/0x1d7cb01027c1c3dfe7494246b4e7c6e7c39af95b): 0x1D7CB01027C1C3dfE7494246B4e7c6E7c39aF95B
-   [CustodialContract 👮‍♂️](https://mumbai.polygonscan.com/address/0x5D8839b19Bc7f772eE486791813CA5E92c3F530E): 0x5D8839b19Bc7f772eE486791813CA5E92c3F530E

### Tokens contracts addresses for Mumbai Testnet ⚙️

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F |
| USDT   | 0xA02f6adc7926efeBBd59Fd43A84f4E0c0c91e832 |
| USDC   | 0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747 |

### Tokens contracts addresses for POLYGON Mainnet 🟣

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x6B175474E89094C44Da98b954EedeAC495271d0F |
| USDT   | 0xdAC17F958D2ee523a2206206994597C13D831ec7 |
| USDC   | 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 |

### How to use in Testnet 🤔

1.  Create your own .env file
2.  Add the specified keys to your .env file
3.  Run `yarn install` or `npm install`
4.  Run the following command to compile and deploy the contract:

```shell
npx hardhat compile
npm run deploy:testnet
```

### Example of Nft metadata 🎨

```json
{
    "owner": "0x",
    "description": "Your Description",
    "totalSupply": "3",
    "index": "1",
    "amount": "100000000000000",
    "broker": "0x",
    "brokerFee": "100",
    "token": "MATIC"
}
```

### Environment variables 📝

| Item            |                           Value |
| --------------- | ------------------------------: |
| TESTNET_RPC     |     Add your alchemy RPC server |
| POLYGON_API_KEY | API Key provided by polygonscan |
| PRIVATE_KEY     |         Your wallet private key |
