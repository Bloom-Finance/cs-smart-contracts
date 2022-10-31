//SPDX-License-Identifier:MIT
pragma solidity 0.7.0;
pragma experimental ABIEncoderV2;
import "./Base64.sol";
import "./jsonParser.sol";
import "./Strings.sol";

// NFTExample ={
//     legalContractBroker:'0xx',
//     legalContractFee:'0xx',
//     legalContractDescription:'0xx',
//     legalContractOwner:'0xx',
//     legalContractName:'0xx',
//     amount:'',
//     precision:'',
//     token:'',
// }
contract NFTReceiptsCS {
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {}

    function ownerOf(uint256 tokenId) external view returns (address) {}

    function tokenURI(uint256 tokenId) external view returns (string memory) {}
}
struct Receipt {
    uint256 tokenId;
    uint256 transactionCompleted;
}

contract CustodialNFT {
    NFTReceiptsCS private nftReceiptsCS;
    mapping(address => Receipt[]) s_receivedReceipts;
    mapping(address => Receipt[]) s_paidReceipts;

    constructor(address NFTReceiptsAddress) {
        nftReceiptsCS = NFTReceiptsCS(NFTReceiptsAddress);
    }

    function getNFTReceiptsAddress() public view returns (address) {
        return address(nftReceiptsCS);
    }

    function getNFTMetaData(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        string memory myBase64 = nftReceiptsCS.tokenURI(tokenId);
        string memory myJson = Base64.decode(myBase64);
        return myJson;
    }

    function buyNFT(uint256 tokenId) public payable returns (address) {
        string memory metadata = getNFTMetaData(tokenId);
        address contractOwner;
        address broker;
        uint256 amount;
        uint256 brokerFee;
        NFTMetadata[] memory myArray = JsonParser.proccessJSON(
            metadata,
            JsonParser.calculateQuantity(8)
        );
        for (uint256 i = 0; i < myArray.length; i++) {
            if (Strings.compareStrings(myArray[i].key, "owner")) {
                contractOwner = Strings.toAddress(myArray[i].value);
            }
            if (Strings.compareStrings(myArray[i].key, "amount")) {
                (amount, ) = Strings.strToUint(myArray[i].value);
            }
            if (Strings.compareStrings(myArray[i].key, "brokerFee")) {
                (brokerFee, ) = Strings.strToUint(myArray[i].value);
            }
            if (Strings.compareStrings(myArray[i].key, "broker")) {
                broker = Strings.toAddress(myArray[i].value);
            }
        }
        require(msg.value == amount, "You must pay the exact amount");
        if (brokerFee > 0) {
            uint256 fee = calculateFee(amount, brokerFee);
            require(
                address(this).balance > fee,
                "Fee is greater than the amount sent"
            );
            payable(contractOwner).transfer(amount - fee);
            payable(broker).transfer(fee);
        } else {
            payable(contractOwner).transfer(amount);
        }
        nftReceiptsCS.transferFrom(address(this), msg.sender, tokenId);
        s_receivedReceipts[contractOwner].push(
            Receipt(tokenId, block.timestamp)
        );
        s_paidReceipts[msg.sender].push(Receipt(tokenId, block.timestamp));
    }

    function getReceivedReceiptsByAddress(address _address)
        public
        view
        returns (Receipt[] memory)
    {
        return s_receivedReceipts[_address];
    }

    function getPaidReceiptsByAddress(address _address)
        public
        view
        returns (Receipt[] memory)
    {
        return s_paidReceipts[_address];
    }

    function calculateFee(uint256 amount, uint256 percentage)
        internal
        pure
        returns (uint256)
    {
        //uint256 private percentage = 100; // 1% in basis points
        return (amount * percentage) / 10000;
    }
}
