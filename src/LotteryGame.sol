// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title LotteryGame
 * @dev A simple number guessing game where players can win ETH prizes
 */
contract LotteryGame {
    struct Player {
        uint256 attempts;
        bool active;
    }

    // TODO: Declare state variables
    // - Mapping for player information
    mapping(address => Player) public players;
    // - Array to track player addresses
    address[] public playersAddress;
    // - Total prize pool
    uint256 public totalPrizePool;
    // - Array for winners
    address[] public winners;
    // - Array for previous winners
    address[] public prevWinners;


    // TODO: Declare events
    // - PlayerRegistered
    event PlayerRegistered(address indexed players, uint256 stakedAmount);
    // - GuessResult
    event GuessResult(address indexed player, uint256 guess, bool wasCorrect);
    // - PrizesDistributed
    event PrizesDistributed(uint256 prizePerWinner, uint256 totalPrize);

    /**
     * @dev Register to play the game
     * Players must stake exactly 0.02 ETH to participate
     */
    function register(uint256 paymentAmount) public payable {
        // TODO: Implement registration logic
        // - Verify correct payment amount
        require(paymentAmount == 0.02 ether, 'Must stake 0.02ETH to be able to register');
        // - Add player to mapping
        players[msg.sender] = Player({attempts: 3, active: true});
        // - Add player address to array
        playersAddress.push(msg.sender);
        // - Update total prize
        totalPrizePool += paymentAmount;
        // - Emit registration event
        emit PlayerRegistered(msg.sender, paymentAmount);
    }

    /**
     * @dev Make a guess between 1 and 9
     * @param guess The player's guess
     */
    function guessNumber(uint256 guess) public {
        // TODO: Implement guessing logic
        // - Validate guess is between 1 and 9
        // - Check player is registered and has attempts left
        // - Generate "random" number
        // - Compare guess with random number
        // - Update player attempts
        // - Handle correct guesses
        // - Emit appropriate event
    }

    /**
     * @dev Distribute prizes to winners
     */
    function distributePrizes() public {
        // TODO: Implement prize distribution logic
        // - Calculate prize amount per winner
        // - Transfer prizes to winners
        // - Update previous winners list
        // - Reset game state
        // - Emit event
    }

    /**
     * @dev View function to get previous winners
     * @return Array of previous winner addresses
     */
    function getPrevWinners() public view returns (address[] memory) {
        // TODO: Return previous winners array
    }

    /**
     * @dev Helper function to generate a "random" number
     * @return A uint between 1 and 9
     * NOTE: This is not secure for production use!
     */
    function _generateRandomNumber() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))) % 9 + 1;
    }
}
