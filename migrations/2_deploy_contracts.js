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

    deployer.deploy(SafeMath);
    deployer.deploy(Ownable);
    deployer.link(Ownable, Pausable);
    deployer.deploy(Pausable);

    deployer.deploy(BasicToken);
    deployer.link(BasicToken, SafeMath);
    deployer.link(BasicToken, ERC20Basic);

    deployer.deploy(StandardToken);
    deployer.link(StandardToken, BasicToken);

    deployer.deploy(CoinFiToken);
    deployer.link(CoinFiToken, StandardToken);
    deployer.link(CoinFiToken, Ownable);
    deployer.link(CoinFiToken, BurnableToken);
    deployer.link(CoinFiToken, SafeMath);

    var time = new Date().getTime() / 1000;

    deployer.deploy(CoinFiToken, accounts[1]).then(function() {
        return deployer.deploy(CoinFiSale);
    });
};
