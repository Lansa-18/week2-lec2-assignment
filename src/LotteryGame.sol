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
    uint256 public totalPrize;
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
    event PrizesDistributed(uint256 individualPrize, uint256 totalPrize);

    /**
     * @dev Register to play the game
     * Players must stake exactly 0.02 ETH to participate
     */
    function register() public payable {
        // TODO: Implement registration logic
        // - Verify correct payment amount
        require(msg.value == 0.02 ether, "Please stake 0.02 ETH");
        // - Add player to mapping
        players[msg.sender] = Player({attempts: 0, active: true});
        // - Add player address to array
        playersAddress.push(msg.sender);
        // - Update total prize
        totalPrize += msg.value;
        // - Emit registration event
        emit PlayerRegistered(msg.sender, msg.value);
    }

    /**
     * @dev Make a guess between 1 and 9
     * @param guess The player's guess
     */
    function guessNumber(uint256 guess) public {
        // TODO: Implement guessing logic
        // - Validate guess is between 1 and 9
        require(guess >= 1 && guess <= 9, "Number must be between 1 and 9");
        // - Check player is registered and has attempts left
        require(players[msg.sender].active, "Player is not active");
        require(players[msg.sender].attempts < 2, "Player has already made 2 attempts");

        // - Update player attempts
        players[msg.sender].attempts++;

        // - Generate "random" number
        uint256 randomNumber = _generateRandomNumber();

        // - Compare guess with random number
        bool isCorrect = (randomNumber == guess);

        // - Handle correct guesses
        if (isCorrect) {
            winners.push(msg.sender);
        }
        // - Emit appropriate event
        emit GuessResult(msg.sender, guess, isCorrect);
    }

    /**
     * @dev Distribute prizes to winners
     */
    function distributePrizes() public {
        // TODO: Implement prize distribution logic
        require(winners.length > 0, "No winners to distribute prizes to");
        require(totalPrize > 0, "No prizes to distribute.");

        // - Calculate prize amount per winner
        uint256 prizePerWinner = totalPrize / winners.length;
        uint256 remainingDust = totalPrize - (prizePerWinner * winners.length);

        // - Transfer prizes to winners
        for (uint256 i = 0; i < winners.length; i++) {
            uint256 amount = prizePerWinner;

            // Adding any dust lost from the earlier division to the winner
            if (i == winners.length - 1) {
                amount += remainingDust;
            }

            (bool success,) = payable(winners[i]).call{value: amount}("");
            require(success, "Failed to transfer the prize.");
        }

        // - Update previous winners list
        for (uint256 i = 0; i < winners.length; i++) {
            prevWinners.push(winners[i]);
        }

        // - Reset game state
        for (uint256 i = 0; i < playersAddress.length; i++) {
            delete players[playersAddress[i]];
        }
        delete playersAddress;
        delete winners;

        uint256 distributedAmount = totalPrize;
        totalPrize = 0;

        // - Emit event
        emit PrizesDistributed(prizePerWinner, distributedAmount);
    }

    /**
     * @dev View function to get previous winners
     * @return Array of previous winner addresses
     */
    function getPrevWinners() public view returns (address[] memory) {
        // TODO: Return previous winners array
        return prevWinners;
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
