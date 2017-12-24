pragma solidity 0.4.19;


contract CrowdsaleConfig {
    uint256 private constant TOKEN_DECIMALS = 18;
    uint256 private constant MIN_UNIT = 10 ** uint256(TOKEN_DECIMALS);

    // 300M maximum COFI tokens
    uint256 public constant TOTAL_SUPPLY_CAP = 300000000 * MIN_UNIT;

    // 150M maximum COFI tokens sold
    uint256 public constant SALE_CAP = 150000000 * MIN_UNIT;

    // 16.7% of total tokens allocated for presale
    uint256 public constant PRESALE_CAP = 50100000 * MIN_UNIT;

    // 20% of total tokens allocated for community contributors
    uint256 public constant FOUNDATION_POOL_TOKENS = 60000000 * MIN_UNIT;

    // 30% of total tokens allocated for team, 2 year lockup
    uint256 public constant TEAM_TOKENS_VESTED = 90000000 * MIN_UNIT;

    // Minimum amount a contributor can purchase; TBD
    // uint256 public constant PURCHASE_MIN_CAP_WEI = 0;

    // Maximum amount a contributor can purchase; TBD
    // uint256 public constant PURCHASE_MAX_CAP_WEI = 0;
}
