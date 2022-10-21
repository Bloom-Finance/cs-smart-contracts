//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";

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

// library JSONParser {
//     function parse(string memory json, uint256 numberElements)
//         internal
//         pure
//         returns (
//             uint256,
//             Token[] memory tokens,
//             uint256
//         )
//     {}
// }

contract CustodialNFT {
    using Strings for uint256;
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

    function buyNFT(uint256 tokenId) public view returns (string memory) {
        // staff
    }
}
