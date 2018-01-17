pragma solidity 0.4.18;

import "./math/SafeMath.sol";
import "./token/StandardToken.sol";
import "./ownership/Ownable.sol";
//import "./CoinFiCrowdsale.sol";


/**
 * @title CoinFiToken
 * @dev CoinFi Token implementation.
 */
contract CoinFiToken is StandardToken, Ownable {
    string public constant name = "CoinFi Token";
    string public constant symbol = "COFI";
    uint8 public constant decimals = 18;

    uint256 public constant DECIMALS_FACTOR     = 10 ** uint256(decimals);
    uint256 public constant TOKEN_SUPPLY        = 300000000 * DECIMALS_FACTOR;
    uint256 public constant PUBLIC_SALE_TOKENS  =  12000000 * DECIMALS_FACTOR;
    uint256 public constant PRIVATE_SALE_TOKENS = 138000000 * DECIMALS_FACTOR;
    uint256 public constant FOUNDATION_TOKENS   =  60000000 * DECIMALS_FACTOR;
    uint256 public constant TEAM_TOKENS         =  90000000 * DECIMALS_FACTOR;

    // Properties
    uint256 public tokenSupply;             // Total number of tokens
    uint256 public publicSaleSupply;        // Number of tokens available for public sale

    address public publicSaleAddress;       // Address of public sale smart contract
    address public adminAddress;            // Address of sale administrator for manual distribution to private participants

    bool public transferEnabled = false;    // Indicates whether token transfer is enabled

    // Modifiers
    modifier onlyWhenTransferEnabled() {
        if (!transferEnabled) {
            require(msg.sender == adminAddress || msg.sender == publicSaleAddress);
        }
        _;
    }

    /**
     * Ensures that the listed addresses are not valid recipients of tokens.
     *
     * 0x0           - the zero address is not valid
     * this          - the contract itself should not receive tokens
     * owner         - the owner has all the initial tokens, but cannot receive any back
     */
    modifier validDestination(address _to) {
        require(_to != address(0x0));
        require(_to != address(this));
        require(_to != owner);
        _;
    }

    // Constructor: initiates token genesis and allocates balance to admin owner.
    // @param _adminAddress The address of the administrator
    function CoinFiToken(address _admin) public {
        require(msg.sender != _admin);

        tokenSupply = TOKEN_SUPPLY;
        publicSaleSupply = PUBLIC_SALE_TOKENS;

        // Genesis; mint all tokens
        balances[msg.sender] = tokenSupply;
        Transfer(address(0x0), msg.sender, tokenSupply);

        adminAddress = _admin;
        approve(adminAddress, tokenSupply);
    }

    /**
     * Associates this token with an existing public sale smart contract,
     * allocating the contract an allowance of tokens from the public sale supply.
     * This gives the public sale the ability to call transferFrom() to transfer
     * tokens to whomever has purchased them.
     *
     * @param _publicSaleAddress The address of the public sale contract that will sell this token
     * @param _amountOfTokens The supply of tokens provided to the public sale
     */
    function allocateToPublicSale(address _publicSaleAddress, uint256 _amountOfTokens) external onlyOwner {
        require(!transferEnabled);
        require(_amountOfTokens <= publicSaleSupply);

        // Clear old allocation and set allocation of new;
        // Note this operation supports different contract addresses
        approve(publicSaleAddress, 0);
        approve(_publicSaleAddress, _amountOfTokens);

        publicSaleAddress = _publicSaleAddress;
    }

    /**
     * Enables everyone to start transferring their tokens.
     * This can only be called by the token owner.
     * Once enabled, disabling transfers no longer possible.
     */
    function enableTransfer() external onlyOwner {
        transferEnabled = true;
    }

    function disableTransfer() external onlyOwner {
        transferEnabled = false;
    }

    /**
     * Overrides the ERC20 transfer() function to only allow token transfers after enableTransfer() is called.
     */
    /* function transfer(address _to, uint256 _value) public returns (bool) {
        return super.transfer(_to, _value);
    } */

    /**
     * Overrides the ERC20 transferFrom() function to only allow token transfers after enableTransfer() is called.
     */
    function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }
}
