pragma solidity 0.4.18;


import "./ownership/Ownable.sol";
import "./token/ERC20Basic.sol";
import "./CoinFiToken.sol";

contract CoinFiAirdrop is Ownable {
    uint256 public constant AIRDROP_AMOUNT = 500 * (10**18);

    // Actual token instance to airdrop
    CoinFiToken public token;

    // Array of airdrop recipients
    /* address[] public airdropRecipients; */

    function CoinFiAirdrop(CoinFiToken _token) public {
        token = _token;
    }

    /* function getAirdropRecipients() public view returns (address[]) {
        return airdropRecipients;
    } */

    /* function setAirdropRecipients(address[] whitelistAddresses) external onlyOwner {
        airdropRecipients = whitelistAddresses;
    } */

    function sendAirdrop(address[] airdropRecipients) external onlyOwner {
        require(airdropRecipients.length > 0);

        for (uint i = 0; i < airdropRecipients.length; i++) {
            token.transfer(airdropRecipients[i], AIRDROP_AMOUNT);
        }
    }
}
