//SPDX-License-Identifier:MIT
pragma solidity 0.7.0;
pragma experimental ABIEncoderV2;
import "./Base64.sol";
import "./jsonParser.sol";
import "./Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
struct TokenMetadata {
    address owner;
    uint256 amount;
    uint256 brokerFee;
    address broker;
    string token;
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

    function buyNFTWithDAI(uint256 tokenId, uint256 amountToPay) public {
        TokenMetadata memory tokenMetadata = getAsStructToken(tokenId);
        require(
            tokenMetadata.amount == amountToPay,
            "You are not paying the right amount"
        );
        require(
            Strings.compareStrings(tokenMetadata.token, "DAI"),
            "You are not paying the right token"
        );
    }

    function buyNFT(uint256 tokenId) public payable {
        TokenMetadata memory tokenMetadata = getAsStructToken(tokenId);
        require(
            msg.value == tokenMetadata.amount,
            "You must pay the exact amount"
        );
        if (tokenMetadata.brokerFee > 0) {
            uint256 fee = calculateFee(
                tokenMetadata.amount,
                tokenMetadata.brokerFee
            );
            require(
                address(this).balance > fee,
                "Fee is greater than the amount sent"
            );
            payable(tokenMetadata.owner).transfer(tokenMetadata.amount - fee);
            payable(tokenMetadata.broker).transfer(fee);
        } else {
            payable(tokenMetadata.owner).transfer(tokenMetadata.amount);
        }
        nftReceiptsCS.transferFrom(address(this), msg.sender, tokenId);
        s_receivedReceipts[tokenMetadata.owner].push(
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

    function getAsStructToken(uint256 tokenId)
        private
        view
        returns (TokenMetadata memory)
    {
        string memory metadata = getNFTMetaData(tokenId);
        address contractOwner;
        address broker;
        uint256 amount;
        uint256 brokerFee;
        string memory token;
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
            if (Strings.compareStrings(myArray[i].key, "token")) {
                token = myArray[i].value;
            }
        }
        return TokenMetadata(contractOwner, amount, brokerFee, broker, token);
    }
}
