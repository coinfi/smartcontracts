var SafeMath = artifacts.require("./math/SafeMath.sol");

var ERC20 = artifacts.require("./token/ERC20.sol");
var ERC20Basic = artifacts.require("./token/ERC20Basic.sol");
var BasicToken = artifacts.require("./token/BasicToken.sol");
var StandardToken = artifacts.require("./token/StandardToken.sol");
var BurnableToken = artifacts.require("./token/BurnableToken.sol");

var Ownable = artifacts.require("./ownership/Ownable.sol");

var Pausable = artifacts.require("./lifecycle/Pausable.sol");

var CoinFiToken = artifacts.require("./CoinFiToken.sol");
var CoinFiSale = artifacts.require("./CoinFiSale.sol");


module.exports = function(deployer, network, accounts) {
    console.log("Accounts: " + accounts);
    //var time = new Date().getTime() / 1000;

    deployer.deploy(CoinFiToken, accounts[1]).then(function() {
      console.log("Beneficiary account: ", accounts[1]);
      return deployer.deploy(
        CoinFiSale,
        accounts[1], // beneficiary
        0.25, // min individual contribution in ETH
        15, // max individual contribution in ETH
        1515359912, // UNIX timestamp of start of sale
        7500, // COFI:ETH conversion rate
        CoinFiToken.address
      );
    });
};
