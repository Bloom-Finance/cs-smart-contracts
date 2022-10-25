//SPDX-License-Identifier:MIT
pragma solidity 0.7.0;
import "./Base64.sol";
import "./jsonParser.sol";

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

contract CustodialNFT {
    NFTReceiptsCS private nftReceiptsCS;

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
        uint256 amount;
        NFTMetadata[] memory myArray = JsonParser.proccessJSON(
            metadata,
            JsonParser.calculateQuantity(2)
        );
        for (uint256 i = 0; i < myArray.length; i++) {
            if (compareStrings(myArray[i].key, "legalContractOwner")) {
                contractOwner = toAddress(myArray[i].value);
            }
            if (compareStrings(myArray[i].key, "amount")) {
                (amount, ) = strToUint(myArray[i].value);
            }
        }
        require(msg.value == amount, "You must pay the exact amount");
        nftReceiptsCS.transferFrom(address(this), msg.sender, tokenId);
        payable(contractOwner).transfer(amount);
    }

    function compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }

    function fromHexChar(uint8 c) public pure returns (uint8) {
        if (bytes1(c) >= bytes1("0") && bytes1(c) <= bytes1("9")) {
            return c - uint8(bytes1("0"));
        }
        if (bytes1(c) >= bytes1("a") && bytes1(c) <= bytes1("f")) {
            return 10 + c - uint8(bytes1("a"));
        }
        if (bytes1(c) >= bytes1("A") && bytes1(c) <= bytes1("F")) {
            return 10 + c - uint8(bytes1("A"));
        }
        return 0;
    }

    function hexStringToAddress(string memory s)
        internal
        pure
        returns (bytes memory)
    {
        bytes memory ss = bytes(s);
        require(ss.length % 2 == 0); // length must be even
        bytes memory r = new bytes(ss.length / 2);
        for (uint256 i = 0; i < ss.length / 2; ++i) {
            r[i] = bytes1(
                fromHexChar(uint8(ss[2 * i])) *
                    16 +
                    fromHexChar(uint8(ss[2 * i + 1]))
            );
        }

        return r;
    }

    function toAddress(string memory s) internal pure returns (address) {
        bytes memory _bytes = hexStringToAddress(s);
        require(_bytes.length >= 1 + 20, "toAddress_outOfBounds");
        address tempAddress;

        assembly {
            tempAddress := div(
                mload(add(add(_bytes, 0x20), 1)),
                0x1000000000000000000000000
            )
        }

        return tempAddress;
    }

    function strToUint(string memory _str)
        internal
        pure
        returns (uint256 res, bool err)
    {
        for (uint256 i = 0; i < bytes(_str).length; i++) {
            if (
                (uint8(bytes(_str)[i]) - 48) < 0 ||
                (uint8(bytes(_str)[i]) - 48) > 9
            ) {
                return (0, false);
            }
            res +=
                (uint8(bytes(_str)[i]) - 48) *
                10**(bytes(_str).length - i - 1);
        }

        return (res, true);
    }
}
