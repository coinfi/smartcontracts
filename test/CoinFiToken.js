const CoinFiToken = artifacts.require("./CoinFiToken.sol");
const CoinFiSale = artifacts.require("./CoinFiSale.sol");

const DECIMAL_FACTOR = 10**18;
const TOTAL_SUPPLY = 300000000;
const CROWDSALE_SUPPLY = 12000000;

contract("CoinFiToken", function(accounts) {
  // account[0] points to the owner on the testRPC setup
  var ownerAccount     = accounts[0];
  var crowdsaleAccount = accounts[1];
  var user2 = accounts[2];
  var user3 = accounts[3];

  beforeEach(function() {
    return CoinFiSale.deployed().then(function(_tokenSale) {
      sale = _tokenSale;
      return CoinFiToken.deployed();
    }).then(function(_token) {
      token = _token;
      return token.TOKEN_SUPPLY();
    });
  });

  it("has 18 decimal places", async () => {
    let decimals = await token.decimals();
    assert.equal(decimals, 18);
  });

  it("has transferEnabled initialized as false", async () => {
    let result = await token.transferEnabled();
    assert.equal(result, false);
  });

  it("has an initial admin owner balance of 300 million tokens", async () => {
    let ownerBalance = (await token.balanceOf(ownerAccount)).toNumber();
    assert.equal(ownerBalance, TOTAL_SUPPLY * DECIMAL_FACTOR);
  });

  it("disables regular users from transferring tokens before admin unlocks", async () => {
    try { await token.transfer(user2, 1, { from: user3 }); }
    catch (e) { return true; }
    throw new Error("A regular user transferred tokens before they were unlocked");
  });

  it("does not allow a regular user to enable transfers", async () => {
    try { await token.enableTransfer({ from: user2 }); }
    catch (e) { return true; }
    throw new Error("A regular user was able to call enableTransfer()");
  });

  it("should enable transfers after invoking enableTransfer as owner", async function() {
    let isEnabledPrior = await token.transferEnabled();
    assert(!isEnabledPrior, "transfers are not enabled");
    await token.enableTransfer();
    let isEnabledAfter = await token.transferEnabled();
    assert(isEnabledAfter, "transfers should be enabled now");
    // TODO: Actually make a transfer!
  });

  it("allows the owner account to transfer", async () => {
    let amountToTransfer = CROWDSALE_SUPPLY * DECIMAL_FACTOR;

    await token.transfer(sale.address, amountToTransfer);

    let ownerBalance = await token.balanceOf(ownerAccount);
    let crowdsaleBalance = await token.balanceOf(sale.address);
    let crowdsaleSupply = await token.crowdsaleSupply();
    let tokenSupply = await token.tokenSupply();
    ownerBalance = ownerBalance.toNumber();
    crowdsaleBalance = crowdsaleBalance.toNumber();
    crowdsaleSupply = crowdsaleSupply.toNumber();
    tokenSupply = tokenSupply.toNumber();

    assert.equal(ownerBalance, TOTAL_SUPPLY * DECIMAL_FACTOR - amountToTransfer);
    assert.equal(crowdsaleBalance, amountToTransfer, "crowdsale address should end with amount transferred");
    assert.equal(crowdsaleBalance, crowdsaleSupply, "crowdsale address should end with anticipated crowdsale supply");
  });
});

// TODO: Test token transfer functionality.

// TODO: Test token burning functionality.
