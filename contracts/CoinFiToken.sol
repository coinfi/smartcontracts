pragma solidity 0.4.19;

import "zeppelin-solidity/contracts/token/MintableToken.sol";
import "./CoinFiCrowdsale.sol";


/**
 * @title CoinFiToken
 * @dev CoinFi Token implementation.
 */
contract CoinFiToken is MintableToken {
    string public constant NAME = "CoinFi";
    string public constant SYMBOL = "COFI";
    uint256 public constant DECIMALS = 18;

    uint256 public cap;
    bool private transfersEnabled = false;

    /**
     * @dev Only the contract owner can transfer without restrictions.
     *      Regular holders need to wait until sale is finalized.
     * @param _sender — The address sending the tokens
     * @param _value — The number of tokens to send
     */
    modifier canTransfer(address _sender, uint256 _value) {
        require(transfersEnabled || _sender == owner);
        _;
    }

    /**
     * @dev Constructor that sets a maximum supply cap.
     * @param _cap — The maximum supply cap.
     */
    function CoinFiToken(uint256 _cap) public {
        cap = _cap;
    }

    /**
     * @dev Overrides MintableToken.mint() for restricting supply under cap
     * @param _to — The address to receive minted tokens
     * @param _value — The number of tokens to mint
     */
    function mint(address _to, uint256 _value) public onlyOwner canMint returns (bool) {
        require(totalSupply.add(_value) <= cap);
        return super.mint(_to, _value);
    }

    /**
     * @dev Checks modifier and allows transfer if tokens are not locked.
     * @param _to — The address to receive tokens
     * @param _value — The number of tokens to send
     */
    function transfer(address _to, uint256 _value)
        public canTransfer(msg.sender, _value) returns (bool)
    {
        return super.transfer(_to, _value);
    }

    /**
     * @dev Checks modifier and allows transfer if tokens are not locked.
     * @param _from — The address to send tokens from
     * @param _to — The address to receive tokens
     * @param _value — The number of tokens to send
     */
    function transferFrom(address _from, address _to, uint256 _value)
        public canTransfer(_from, _value) returns (bool)
    {
        return super.transferFrom(_from, _to, _value);
    }

    /**
     * @dev Enables token transfers.
     *      Called when the token sale is successfully finalized
     */
    function enableTransfers() public onlyOwner {
        transfersEnabled = true;
    }
}
