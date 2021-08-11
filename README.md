# PixelPals NFT

A generatvie 24x24 pixel-art NFT collection. I built it to learn Solidity during summer 2021.

## Develop

```
npm install
npx hardhat test
```

## Generate art

Put trait PNGs in `generator/layers/<layer>/<name>_<weight>.png` and run `python generator/generate.py`.

## Deploy

Fill in `.env` and run `npm run deploy:rinkeby`, then
`npx hardhat verify --network rinkeby <address> <baseURI>`.
