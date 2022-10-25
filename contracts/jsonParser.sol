//SPDX-License-Identifier:MIT
import "./JsmnLib.sol";
pragma solidity 0.7.0;
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

library JsonParser {
    function calculateQuantity(uint256 quantityOfKeys)
        internal
        pure
        returns (uint256)
    {
        return (quantityOfKeys * 2) + 1;
    }

    // This functions proccess a JSON and then saves each keys to a memory array
    function proccessJSON(string memory json, uint256 length)
        internal
        pure
        returns (NFTMetadata[] memory)
    {
        JsmnSolLib.Token[] memory tokens;
        NFTMetadata[] memory nftMetadata = new NFTMetadata[]((length - 1) / 2);
        uint256 returnValue;

        uint256 actualNum;

        (returnValue, tokens, actualNum) = JsmnSolLib.parse(json, length);

        for (uint256 i = 1; i < tokens.length; i++) {
            uint256 indexKey = i == 1 ? i : i + 1;
            uint256 indexValue = i == 1 ? i + 1 : i + 2;
            uint256 metadataIndex = i - 1;
            if (indexValue > length - 1) {
                break;
            }
            string memory key = JsmnSolLib.getBytes(
                json,
                tokens[indexKey].start,
                tokens[indexKey].end
            );
            string memory value = JsmnSolLib.getBytes(
                json,
                tokens[indexValue].start,
                tokens[indexValue].end
            );
            nftMetadata[metadataIndex] = NFTMetadata(key, value);
        }
        return nftMetadata;
    }
}
