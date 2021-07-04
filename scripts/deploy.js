const hre = require("hardhat");

async function main() {
  const Factory = await hre.ethers.getContractFactory("PixelPals");
  const nft = await Factory.deploy(process.env.BASE_URI || "ipfs://CHANGE_ME/");
  await nft.deployed();
  console.log("PixelPals deployed to:", nft.address);
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
