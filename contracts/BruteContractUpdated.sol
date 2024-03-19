// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract BruteGame is ERC721 {

    // Define the struct for an ability
    struct Ability {
        uint256 id;
        string name;
        string description;
        uint256[] statsToImprove;
        uint256 increaseAmount;
        uint256 requiredLevel;
    }


    // Define the struct for a brute
    struct Brute {
        uint256 id;
        string name;
        uint256 strength;
        uint256 defense;
        uint256 health;
        uint256 energy;
        uint256 level;
        uint256 experience;
        address owner;
        uint256[] abilities; // Dynamic array of ability IDs
    }

    
    // Define the mapping of abilities
    mapping(uint256 => Ability) public abilities;


    // Mapping from brute's id to their Brute struct
    mapping(uint256 => Brute) public brutes;

    // Mapping from user address to array of brute IDs owned by the user
    mapping(address => uint256[]) public userBrutes;


    // Counter for generating unique brute IDs
    uint256 private nextBruteId = 1;

    // Counter for creating unique brute's ability IDs
    uint256 private nextAbilityId = 1;

    // Define the base XP value for reaching level 2
    uint256 constant baseXP = 500;

    // Define base Brute Stats
    uint256 base_strength = 5;
    uint256 base_defense = 3;
    uint256 base_health = 30;
    uint256 base_energy = 6;
    uint256 base_level = 1;
    uint256 base_experience = 0;
    uint256[] base_abilities = new uint256[](0);


    uint256 xpForWin = 300;
    uint256 xpForLoss = 175;


    constructor() ERC721("Brute", "BRT"){}

    // Function to create a new ability // ONLY OWNER
    function createAbility(string memory name, string memory description, uint256[] memory statsToImprove, uint256 increaseAmount, uint256 requiredLevel) external  {
        uint256 abilityId = nextAbilityId;
        Ability memory newAbility = Ability(abilityId, name, description, statsToImprove, increaseAmount, requiredLevel);
        abilities[abilityId] = newAbility;
        nextAbilityId++;
    }

    // Function to create a new brute and mint an associated NFT
    function createBrute(string memory name) external {
        // Generate a new brute ID
        uint256 bruteId = nextBruteId;

        // Create the new brute
        Brute memory newBrute = Brute(bruteId, name, base_strength, base_defense, base_health, base_energy, base_level, base_experience, msg.sender, base_abilities);
        brutes[bruteId] = newBrute;

        // Mint an NFT representing the new brute
        _safeMint(msg.sender, bruteId);
        nextBruteId++;
    }

    // Helper Function to calculate the XP required for the next level
    function calculateXPForNextLevel(uint256 currentLevel) public pure  returns (uint256) {
        return baseXP * currentLevel;
    }

    // Function to update brute's level based on their experience
    function updateLevel(uint256 bruteId) public {
        Brute storage brute = brutes[bruteId];
        uint256 requiredXP = calculateXPForNextLevel(brute.level);
        if (brute.experience >= requiredXP) {
            brute.level++;
        }
    }

    // Helper Function to handle XP gained from a combat
    function handleXP(uint256 bruteId, uint256 xpGained) internal {
        Brute storage brute = brutes[bruteId];
        brute.experience += xpGained;
        updateLevel(bruteId);
    }

    // Helper Function to handle energy decrease
    function decreaseBruteEnergy(uint256 bruteId) internal {
        Brute storage brute = brutes[bruteId];
        if(brute.energy == 1){
            brute.energy = 0;
        } else {
            brute.energy = brute.energy-1;
        }
    }

    // Helper Function to reset Brute's energy
    function resetBruteEnergy(uint256 bruteId) internal {
        Brute storage brute = brutes[bruteId];
        brute.energy = base_energy;
    }

    // Function to send Brute to hospital to recover energy
    function sendBruteToHospital(uint256 bruteId) public {
        Brute memory brute = brutes[bruteId];
        require(brute.energy != base_health, "Brute has full energy");
        resetBruteEnergy(bruteId);
    }

    // Helper Function to reset health after combat
    function resetBruteHealth(uint256 bruteId, uint256 health) internal {
        Brute storage brute = brutes[bruteId];
        brute.health = health;
    }

    // Helper Function to update stats of brute after assigning ability
    function handleAbilityAssignToBrute(uint256 bruteId, uint256 abilityId) internal {
        Brute storage brute = brutes[bruteId];
        Ability storage ability = abilities[abilityId];

        // Ensure brute and ability exist
        require(brute.id != 0 && ability.id != 0, "Brute or ability does not exist");

        // Iterate over statsToImprove array and update corresponding stats of the brute
        for (uint256 i = 0; i < ability.statsToImprove.length; i++) {
            if (ability.statsToImprove[i] == 0) {
                brute.strength += ability.increaseAmount;
            } else if (ability.statsToImprove[i] == 1) {
                brute.defense += ability.increaseAmount;
            } else if (ability.statsToImprove[i] == 2) {
                brute.health += ability.increaseAmount;
            }
        }
    }

    // Function to assign an ability to a brute
    function assignAbilityToBrute(uint256 bruteId, uint256 abilityId) external {
        Brute storage brute = brutes[bruteId];
        Ability storage ability = abilities[abilityId];
        require(brute.owner == msg.sender, "You do not own this brute");

        // Check if the level is compatible with ability 
        require(brute.level >= ability.requiredLevel, "Level is lower than required to gain ability");

        require(abilities[abilityId].id != 0, "Ability does not exist");

        // Check if the brute already has the ability
        require(!hasAbility(bruteId, abilityId), "Brute already has this ability");

        // Assign the ability to the brute
        brute.abilities.push(abilityId);
        handleAbilityAssignToBrute(bruteId, abilityId);
    }

    // Helper Function to check if a brute has a specific ability
    function hasAbility(uint256 bruteId, uint256 abilityId) public view returns (bool) {
        Brute storage brute = brutes[bruteId];
        for (uint256 i = 0; i < brute.abilities.length; i++) {
            if (brute.abilities[i] == abilityId) {
                return true;
            }
        }
        return false;
    }

    // Function to simulate combat and distribute XP gained from a combat to brutes
    function resolveCombatAndDistributeXP(uint256 bruteId1, uint256 bruteId2) public returns (uint256 winnerId) {
        // Get the brutes from their IDs
        Brute storage brute1 = brutes[bruteId1];
        Brute storage brute2 = brutes[bruteId2];

        // Ensure both brutes exist
        require(brute1.id != 0 && brute2.id != 0, "Brute does not exist");

        // Ensure brute1 owner is caller
        require(brute1.owner == msg.sender, "You do not own this brute");

        // Ensure brute2 is not of owner of brute1
        require(brute2.owner != msg.sender, "You own both brutes");

        // Ensure brute1 has enough energy to combat
        require(brute1.energy >= 1, "Your brute has no energy");

        // Keep a copy of brutes health
        uint256 health1 = brute1.health;
        uint256 health2 = brute2.health;

        // Update brute's energy
        decreaseBruteEnergy(bruteId1);

        // Combat loop
        while (brute1.health > 0 && brute2.health > 0) {
            // Brute 1 attacks Brute 2
            uint256 attack1 = brute1.strength;
            uint256 defense2 = brute2.defense;

            if (attack1 > defense2) {
                if((attack1 - defense2) > brute2.health){
                    brute2.health = 0;
                } else {
                    brute2.health -= (attack1 - defense2);
                }
                
            }

            // Check if Brute 2 is defeated
            if (brute2.health <= 0) {
                // Brute 1 wins
                handleXP(bruteId1, xpForWin);
                //handleXP(bruteId2, xpForLoss);

                // Reset Brutes health
                resetBruteHealth(bruteId1, health1);
                resetBruteHealth(bruteId2, health2);
                return bruteId1;
            }

            // Brute 2 attacks Brute 1
            uint256 attack2 = brute2.strength;
            uint256 defense1 = brute1.defense;
            if (attack2 > defense1) {
                if((attack2 - defense1) > brute2.health){
                    brute1.health = 0;
                } else {
                    brute1.health -= (attack2 - defense1);
                }
                
            }

            // Check if Brute 1 is defeated
            if (brute1.health <= 0) {
                // Brute 2 wins
                handleXP(bruteId1, xpForLoss);
                //handleXP(bruteId2, xpForWin);
                resetBruteHealth(bruteId1, health1);
                resetBruteHealth(bruteId2, health2);
                return bruteId2;
            }

            // If both brutes have 0 health simultaneously, break out of the loop
            if (brute1.health == 0 && brute2.health == 0) {
                handleXP(bruteId1, 200);
                //handleXP(bruteId2, 200);
                resetBruteHealth(bruteId1, health1);
                resetBruteHealth(bruteId2, health2);
                break;
            }
        } 
    }




}

