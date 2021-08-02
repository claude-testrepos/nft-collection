// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract PixelPals is ERC721, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_PER_TX = 5;
    uint256 public price = 0.01 ether;
    uint256 public totalSupply;
    bool public saleActive;
    string private baseURI;

    constructor(string memory _baseURI) ERC721("PixelPals", "PXP") {
        baseURI = _baseURI;
    }

    function mint(uint256 amount) external payable {
        require(saleActive, "sale not active");
        require(amount > 0 && amount <= MAX_PER_TX, "bad amount");
        require(totalSupply + amount <= MAX_SUPPLY, "sold out");
        require(msg.value >= price * amount, "not enough ETH");
        for (uint256 i = 0; i < amount; i++) {
            totalSupply++;
            _safeMint(msg.sender, totalSupply);
        }
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_exists(id), "nonexistent token");
        return string(abi.encodePacked(baseURI, id.toString(), ".json"));
    }

    /// Mint a few for the team and giveaways.
    function reserve(address to, uint256 amount) external onlyOwner {
        require(totalSupply + amount <= MAX_SUPPLY, "sold out");
        for (uint256 i = 0; i < amount; i++) {
            totalSupply++;
            _safeMint(to, totalSupply);
        }
    }

    function setSaleActive(bool active) external onlyOwner { saleActive = active; }
    function setPrice(uint256 p) external onlyOwner { price = p; }
    function setBaseURI(string calldata uri) external onlyOwner { baseURI = uri; }

    function withdraw() external onlyOwner {
        (bool ok, ) = payable(owner()).call{value: address(this).balance}("");
        require(ok, "withdraw failed");
    }
}
