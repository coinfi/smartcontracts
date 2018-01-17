var CoinFiToken = artifacts.require("./CoinFiToken.sol");
var CoinFiAirdrop = artifacts.require("./CoinFiAirdrop.sol");
var rl = require('readlines');
var web3 = require('web3');
var cleanAddr = [];

async  function liveDeploy(deployer, accounts) {
  console.log('deployer?',accounts[0])
  await deployer.deploy(CoinFiToken);
  const token = await CoinFiToken.deployed();
  await deployer.deploy(CoinFiAirdrop, token.address);
  const airdrop = await CoinFiAirdrop.deployed();
  console.log("truffle deployed airdrop address", airdrop.address);
  await token.allocateToAirdrop(airdrop.address);
  console.log('airdrop.token',await airdrop.token())
  console.log('before airdrop', await token.balanceOf(accounts[1]))
  await airdrop.sendAirdrop([accounts[1]])
  console.log('after airdrop', await token.balanceOf(accounts[1]))
}

module.exports = function(deployer, network, accounts) {
  return liveDeploy(deployer, accounts);
};
