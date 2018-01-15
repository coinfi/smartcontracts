pragma solidity 0.4.18;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}


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
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

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


contract CoinFiToken is BasicToken, Ownable {
    string public constant name = "CoinFi";
    string public constant symbol = "COFI";
    uint8 public constant decimals = 18;

    // 300 million tokens minted
    uint256 public constant INITIAL_SUPPLY = 300000000 * (10 ** uint256(decimals));
    uint public constant AIRDROP_AMOUNT = 500 * (10 ** uint256(decimals));

    // Array of airdrop recipients
    address[] public airdropRecipients;

    // Indicates whether token transfer is enabled
    bool public transferEnabled = false;

    modifier onlyWhenTransferEnabled() {
        if (!transferEnabled) {
            require(msg.sender == owner);
        }
        _;
    }

    function CoinFiToken() public {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        Transfer(0x0, msg.sender, INITIAL_SUPPLY);
    }

    function setAirdropRecipients(address[] whitelistAddresses) external onlyOwner {
        airdropRecipients = whitelistAddresses;
    }

    function getAirdropRecipients() public view returns (address[]) {
        return airdropRecipients;
    }

    function sendAirdrop() external onlyOwner {
        require(airdropRecipients.length > 0);

        for (uint i = 0; i < airdropRecipients.length; i++) {
            transfer(airdropRecipients[i], AIRDROP_AMOUNT);
        }
    }

    /**
     * Enables everyone to start transferring their tokens.
     * This can only be called by the token owner.
     * Once enabled, disabling transfers no longer possible.
     */
    function enableTransfer() external onlyOwner {
        transferEnabled = true;
    }

    /**
     * Overrides the ERC20Basic transfer() function to only allow token transfers after enableTransfer() is called.
     */
    function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
        return super.transfer(_to, _value);
    }
}

