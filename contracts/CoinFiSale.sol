pragma solidity 0.4.18;

import "./math/SafeMath.sol";
import "./lifecycle/Pausable.sol";
import "./CoinFiToken.sol";


/**
 * @title CoinFiSale
 * @dev CoinFi Public Token Sale implementation.
 */
contract CoinFiSale is Pausable {
    using SafeMath for uint256;

    CoinFiToken public tokenReward;

    // Beneficiary is the account who receives the deposited ETH after end of public sale
    address public beneficiary;

    // The public sale has the following parameters:
    uint public publicSaleHardCap;   // in ETH
    uint public minimumContribution; // in ETH
    uint public maximumContribution; // in ETH
    bool public saleCapReached = false;
    bool public saleClosed = false;

    // Time period of sale in UNIX epoch
    uint public startTime;
    //uint public endTime;

    // Keeps track of the amount of wei raised
    uint public amountRaised; // in wei

    // The locked in COFI:ETH conversion rate
    uint public conversionRate;
    uint public constant LOW_RANGE_RATE = 5000;
    uint public constant HIGH_RANGE_RATE = 20000;

    // Prevent recursion in specified functions
    bool private recursionLock = false;

    // Map to track the amount of wei contributed by address
    mapping(address => uint256) public balanceOf;

    // Events
    event CapReached(address _beneficiary, uint _amountRaised);
    event FundTransfer(address _backer, uint _amount, bool _isContribution);

    // Modifiers
    modifier afterStartTime() {
        require (currentTime() >= startTime);
        _;
    }

    modifier saleNotClosed() {
        require (!saleClosed);
        _;
    }

    modifier preventRecursion() {
        require(!recursionLock);
        recursionLock = true;
        _;
        recursionLock = false;
    }

    /**
     * Constructor for pubic sale of CoinFi tokens
     *
     * @param _beneficiary The address where raised funds gets sent
     * @param _publicSaleCapInEth The maximum ETH to be raised in the public sale
     * @param _minimumContribution The minimum ETH accepted by the smart contract per address
     * @param _maximumContribution The maximum ETH accepted by the smart contract per address
     * @param _startTimestamp UNIX timestamp for when the smart contract should start accepting funds
     * @param _rateOfCofiToEther Conversion rate from COFI to ETH
     * @param _addressOfToken The smart contract address of the COFI token
     */
    function CoinFiSale(
        address _beneficiary,
        uint _publicSaleCapInEth,
        uint _minimumContribution,
        uint _maximumContribution,
        uint _startTimestamp,
        uint _rateOfCofiToEther,
        address _addressOfToken
    ) public {
        //require(_beneficiary != address(0)) && _beneficiary != address(this));
        //require(_addressOfToken != address(0) && _addressOfToken != address(this));

        beneficiary = _beneficiary;
        publicSaleHardCap = _publicSaleCapInEth;
        minimumContribution = _minimumContribution;
        maximumContribution = _maximumContribution;
        startTime = _startTimestamp;

        setConversionRate(_rateOfCofiToEther);
        //tokenReward = CoinFiToken(_addressOfToken);
    }

   /**
     * This fallback function is called whenever Ether is sent to the
     * smart contract. It can only be executed when the public sale is
     * not paused or closed.
     *
     * This function will update state variables for whether or not the
     * sale cap has been reached. It also ensures that the tokens are
     * transferred to the sender, and that the correct number of tokens
     * are sent according to the current conversion rate.
     */
     /*
    function () public payable whenNotPaused afterStartTime saleNotClosed preventRecursion {
        require(msg.value >= minimumContribution);
        require(msg.value <= maximumContribution);
        // TODO: Check gas limit, reject if over 50 gwei

        // Update the sender's balance of wei contributed and the amount raised
        uint amount = msg.value;
        uint currentBalance = balanceOf[msg.sender];
        balanceOf[msg.sender] = currentBalance.add(amount);
        amountRaised = amountRaised.add(amount);

        // Calculate the number of tokens to deliver to contributor
        // Note that the COFI token declaration must have 18 decimal places!
        uint numTokens = amount.mul(conversionRate);

        // Transfer the tokens from the public sale supply to the contributor
        if (tokenReward.transferFrom(tokenReward.owner(), msg.sender, numTokens)) {
            FundTransfer(msg.sender, amount, true);
            // Check if the public sale cap has been reached
            checkSaleCap();
        }
        else {
            revert();
        }
    }
    */

    /**
     * The owner can update the conversion rate from COFI to ETH if necessary.
     *
     * @param _rate The new conversion rate from COFI to ETH
     */
    function setConversionRate(uint _rate) public onlyOwner {
        require(_rate >= LOW_RANGE_RATE && _rate <= HIGH_RANGE_RATE);
        conversionRate = _rate;
    }

    /**
     * Checks if the public sale hard cap has been reached.
     * Once reached, the CapReached event is triggered.
     */
    function checkSaleCap() internal {
        if (!saleCapReached) {
            if (amountRaised >= publicSaleHardCap) {
                saleCapReached = true;
                CapReached(beneficiary, amountRaised);
            }
        }
    }

    /**
     * Returns the current time.
     * Useful to abstract calls to "now" for tests.
    */
    function currentTime() internal constant returns (uint _currentTime) {
        return now;
    }
}
