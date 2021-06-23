const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PixelPals", function () {
  let nft, owner, alice;

  beforeEach(async () => {
    [owner, alice] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("PixelPals");
    nft = await Factory.deploy("ipfs://QmTest/");
    await nft.deployed();
  });

  it("rejects mint before sale is active", async () => {
    await expect(nft.connect(alice).mint(1, { value: ethers.utils.parseEther("0.01") }))
      .to.be.revertedWith("sale not active");
  });

  it("mints when paid enough", async () => {
    await nft.setSaleActive(true);
    await nft.connect(alice).mint(2, { value: ethers.utils.parseEther("0.02") });
    expect(await nft.balanceOf(alice.address)).to.equal(2);
    expect(await nft.tokenURI(1)).to.equal("ipfs://QmTest/1.json");
  });

  it("rejects underpayment", async () => {
    await nft.setSaleActive(true);
    await expect(nft.connect(alice).mint(3, { value: ethers.utils.parseEther("0.01") }))
      .to.be.revertedWith("not enough ETH");
  });

  it("only owner can withdraw", async () => {
    await expect(nft.connect(alice).withdraw()).to.be.revertedWith("Ownable: caller is not the owner");
  });
});
