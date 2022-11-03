import {ethers, run, network} from "hardhat";

async function main() {
    try {
        const NFTReceiptsFactory = await ethers.getContractFactory(
            "NFTReceipts"
        );
        const custodialNFTFactory = await ethers.getContractFactory(
            "CustodialNFT"
        );
        const {_dai} = getContractsAddresses(network.config.chainId as any);
        const NFTReceipts = await NFTReceiptsFactory.deploy();
        await NFTReceipts.deployed();
        const CustodialNFT = await custodialNFTFactory.deploy(
            NFTReceipts.address,
            _dai
        );
        await CustodialNFT.deployed();
        console.log("NFTReceipts contract deployed to:", NFTReceipts.address);
        console.log("CustodialNFT contract deployed to:", CustodialNFT.address);
        console.log("Waiting some blocks to be mined ...");
        await NFTReceipts.deployTransaction.wait(8);
        await verify(NFTReceipts.address, []);
        await verify(CustodialNFT.address, [NFTReceipts.address, _dai]);
    } catch (error) {
        console.log(error);
    }
}
async function verify(contractAddress: string, args: any[]) {
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        });
    } catch (error: any) {
        if (error.message.toLowerCase().includes("already verified")) {
            console.log("Contract already verified");
        } else {
            console.log(error);
        }
    }
}
function getContractsAddresses(chainId: 80001 | 137) {
    if (chainId === 80001) {
        //mumbai testnet
        return {
            _dai: "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F",
            _usdc: "0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747",
            _usdt: "0x2DB274b9E5946855B83e9Eac5aA6Dcf2c68a95F3",
        };
    }
    if (chainId === 137) {
        //polygon mainnet
        return {
            _dai: "0x6B175474E89094C44Da98b954EedeAC495271d0F",
            _usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            _usdt: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
        };
    } else {
        throw new Error("Invalid chainId");
    }
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
