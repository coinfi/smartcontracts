var CoinFiSale = artifacts.require("./CoinFiSale.sol");
var CoinFiToken = artifacts.require("./CoinFiToken.sol");

contract('CoinFiSale constructor', function(accounts) {
  // account[0] is the owner
  var owner = accounts[0];
  var user1 = accounts[1];
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

  it("correctly sets up the CoinFi public token sale", async () => {
    let beneficiaryAddress = accounts[1];

    let tokenReward = await sale.tokenReward();
    assert.equal(token.address, tokenReward);

    let amountRaised = (await sale.amountRaised()).toNumber();
    assert.equal(amountRaised, 0);

    let refundAmount = (await sale.refundAmount()).toNumber();
    assert.equal(refundAmount, 0);

    let beneficiary = await sale.beneficiary();
    assert.equal(beneficiary, beneficiaryAddress, "beneficiary address is incorrect");

    let saleCapInEthers = (await sale.saleCap()).toNumber();
    assert.equal(saleCapInEthers, 20 * (10 ** 18), "funding cap is incorrect");

    let minimumContributionInWei = (await sale.minContribution()).toNumber();
    assert.equal(minimumContributionInWei, 1, "minimum contribution in wei is incorrect");

    let rateOfCofiToEther = (await sale.conversionRate()).toNumber();
    assert.equal(rateQspToEther, 5000, "conversion rate from QSP to ETH is incorrect");
  });

  it("refunds contributions prior to start time with no tokens issued", async () => {

  });

  // After start time:
  it("refunds contributions under minimum with no tokens issued")

  it("refunds contributions over maximum with no tokens issued")

  it("refunds contributions exceeding the gas limit with no tokens issued")

  it("refunds contributions from non-whitelisted addresses with no tokens issued")

  it("refunds contributions when the public sale cap is reached with no tokens issued")

  it("accepts and delivers tokens to whitelisted addresses")

  it("allows the admin to pause and unpause the token sale")

  it("does not allow a normal user to pause the token sale")
});
