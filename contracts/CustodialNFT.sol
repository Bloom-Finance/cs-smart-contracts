//SPDX-License-Identifier:MIT
pragma solidity 0.7.0;
import "./Base64.sol";
import "./JsmnLib.sol";

// NFTExample ={
//     legalContractOwner:'0xx',
//     legalContractBroker:'0xx',
//     legalContractFee:'0xx',
//     legalContractDescription:'0xx',
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

struct Token {
    uint256 start;
    bool startSet;
    uint256 end;
    bool endSet;
    uint8 size;
}

struct NFTMetadata {
    string key;
    string value;
}

contract CustodialNFT {
    NFTReceiptsCS private nftReceiptsCS;

    constructor(address NFTReceiptsAddress) {
        nftReceiptsCS = NFTReceiptsCS(NFTReceiptsAddress);
    }

    function getNFTReceiptsAddress() public view returns (address) {
        return address(nftReceiptsCS);
    }

    function seeNFTMetaData(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        string memory myBase64 = nftReceiptsCS.tokenURI(tokenId);
        string memory myJson = Base64.decode(myBase64);
        return myJson;
    }

    function buyNFT() public pure returns (string memory) {
        NFTMetadata[] memory myArray = proccessJSON('{"key":"alex"}', 5);
        return myArray[0].value;
    }

    // This functions proccess a JSON and then saves each keys to a storage map
    function proccessJSON(string memory json, uint256 quantity)
        internal
        pure
        returns (NFTMetadata[] memory)
    {
        JsmnSolLib.Token[] memory tokens;
        NFTMetadata[] memory nftMetadata = new NFTMetadata[](quantity);
        uint256 returnValue;

        uint256 actualNum;

        (returnValue, tokens, actualNum) = JsmnSolLib.parse(json, quantity);

        // for (uint256 i = 0; i < tokens.length; i++) {

        // }
        string memory key = JsmnSolLib.getBytes(
            json,
            tokens[1].start,
            tokens[1].end
        );
        string memory value = JsmnSolLib.getBytes(
            json,
            tokens[2].start,
            tokens[2].end
        );
        nftMetadata[0] = NFTMetadata(key, value);
        return nftMetadata;
    }
}
