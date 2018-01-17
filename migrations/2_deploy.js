var CoinFiToken = artifacts.require("./CoinFiToken.sol");
var CoinFiAirdrop = artifacts.require("./CoinFiAirdrop.sol");
var rl = require('readlines');
var web3 = require('web3');
var cleanAddr = [];

async  function liveDeploy(deployer, accounts) {
  console.log('deployer?',accounts[0],deployer)
  await deployer.deploy(CoinFiToken);
  const token = await CoinFiToken.deployed();
  await deployer.deploy(CoinFiAirdrop, token.address);
  const airdrop = await CoinFiAirdrop.deployed();
  console.log("truffle deployed airdrop address", airdrop.address);

  var lines = rl.readlinesSync('./whitelist.csv');
   for(var i in lines){
     if (web3.utils.isAddress(lines[i])) {
       cleanAddr.push(lines[i]);
     }
   };

   console.log("truffle deployed token address", token.address);

   await token.enableTransfer();
   console.log('airdrop.token',await airdrop.token())
   await airdrop.sendAirdrop([accounts[1]])

}

module.exports = function(deployer, network, accounts) {
  return liveDeploy(deployer, accounts);
};
