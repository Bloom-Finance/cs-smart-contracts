// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;

// Embbed library that decodes base64 strings
library Base64 {
    bytes private constant base64stdchars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    bytes private constant base64urlchars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=";

    function decode(string memory _str) internal pure returns (string memory) {
        require((bytes(_str).length % 4) == 0, "Length not multiple of 4");
        bytes memory _bs = bytes(_str);

        uint256 i = 0;
        uint256 j = 0;
        uint256 dec_length = (_bs.length / 4) * 3;
        bytes memory dec = new bytes(dec_length);

        for (; i < _bs.length; i += 4) {
            (dec[j], dec[j + 1], dec[j + 2]) = dencode4(
                bytes1(_bs[i]),
                bytes1(_bs[i + 1]),
                bytes1(_bs[i + 2]),
                bytes1(_bs[i + 3])
            );
            j += 3;
        }
        while (dec[--j] == 0) {}

        bytes memory res = new bytes(j + 1);
        for (i = 0; i <= j; i++) res[i] = dec[i];

        return string(res);
    }

    function dencode4(
        bytes1 b0,
        bytes1 b1,
        bytes1 b2,
        bytes1 b3
    )
        internal
        pure
        returns (
            bytes1 a0,
            bytes1 a1,
            bytes1 a2
        )
    {
        uint256 pos0 = charpos(b0);
        uint256 pos1 = charpos(b1);
        uint256 pos2 = charpos(b2) % 64;
        uint256 pos3 = charpos(b3) % 64;

        a0 = bytes1(uint8(((pos0 << 2) | (pos1 >> 4))));
        a1 = bytes1(uint8((((pos1 & 15) << 4) | (pos2 >> 2))));
        a2 = bytes1(uint8((((pos2 & 3) << 6) | pos3)));
    }

    function charpos(bytes1 char) internal pure returns (uint256 pos) {
        for (; base64urlchars[pos] != char; pos++) {} //for loop body is not necessary
        require(base64urlchars[pos] == char, "Illegal char in string");
        return pos;
    }
}
