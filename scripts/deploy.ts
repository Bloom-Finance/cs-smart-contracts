import {ethers, run} from "hardhat";

async function main() {
    try {
        const NFTReceiptsFactory = await ethers.getContractFactory(
            "NFTReceipts"
        );
        const custodialNFTFactory = await ethers.getContractFactory(
            "CustodialNFT"
        );
        const NFTReceipts = await NFTReceiptsFactory.deploy();
        await NFTReceipts.deployed();
        const CustodialNFT = await custodialNFTFactory.deploy(
            NFTReceipts.address
        );
        await CustodialNFT.deployed();
        console.log("NFTReceipts contract deployed to:", NFTReceipts.address);
        console.log("CustodialNFT contract deployed to:", CustodialNFT.address);
        console.log("Waiting some blocks to be mined ...");
        await NFTReceipts.deployTransaction.wait(8);
        await verify(NFTReceipts.address, []);
        await verify(CustodialNFT.address, [NFTReceipts.address]);
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
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
