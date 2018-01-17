pragma solidity 0.4.18;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
        owner = msg.sender;
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


contract CoinFiAirdrop is Ownable {
    uint256 public constant AIRDROP_AMOUNT = 500 * (10**18);

    // Actual token instance to airdrop
    ERC20Basic public token;

    // Array of airdrop recipients
    address[] public airdropRecipients;

    function CoinFiAirdrop(ERC20Basic _token) public {
        token = _token;
    }

    function getAirdropRecipients() public view returns (address[]) {
        return airdropRecipients;
    }

    function setAirdropRecipients(address[] whitelistAddresses) external onlyOwner {
        airdropRecipients = whitelistAddresses;
    }

    function sendAirdrop() external onlyOwner {
        require(airdropRecipients.length > 0);

        for (uint i = 0; i < airdropRecipients.length; i++) {
            token.transfer(airdropRecipients[i], AIRDROP_AMOUNT);
        }
    }
}
