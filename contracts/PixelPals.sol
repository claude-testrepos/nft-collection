// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PixelPals is ERC721, Ownable {
    uint256 public totalSupply;

    constructor() ERC721("PixelPals", "PXP") {}

    function mint() external {
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
    }
}
