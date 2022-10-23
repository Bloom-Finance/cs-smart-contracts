import {HardhatUserConfig} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import * as dotenv from "dotenv";
dotenv.config({path: __dirname + "/.env"});
const config: HardhatUserConfig = {
    solidity: {
        compilers: [
            {
                version: "0.8.17",
            },
            {
                version: "0.7.0",
            },
        ],
    },
    networks: {
        mumbai: {
            url: process.env.TESTNET_RPC,
            accounts: [process.env.PRIVATE_KEY as string],
        },
    },
    etherscan: {
        apiKey: process.env.POLYGON_API_KEY,
    },
};

export default config;
