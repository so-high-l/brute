## Introduction:
The Brute Game contract is a game where players can create and own virtual characters called "Brutes." 
These Brutes can engage in combat with each other, gain experience, level up, and acquire special abilities.

## Components:

# Brutes: Each Brute has the following attributes:
Name: A name chosen by the player.
Strength: Determines the Brute's attack power.
Defense: Determines the Brute's ability to defend against attacks.
Health: Represents the Brute's life points. If it reaches zero, the Brute is defeated.
Energy: Used for special abilities (not yet implemented).
Level: Indicates the Brute's current energy (Brutes lose energy points by engaging in combats, for example 6 per day).
Experience: Determines the Brute's progress towards the next level.
Owner: The address of the player who owns the Brute.
Abilities: A list of special abilities that the Brute possesses.

# Abilities: Special powers that Brutes can acquire. Each ability has:
Name: A descriptive name.
Description: Details about the ability's effects.
StatsToImprove: An list indicating which stats the ability enhances (e.g., strength, defense, health).
IncreaseAmount: The amount by which the ability enhances the specified stats.
RequiredLevel: The minimum level required for a Brute to acquire the ability.


## Experience and Leveling System:
In the Brute Game contract, Brutes gain experience points (XP) through combat. As they accumulate XP, they level up, improving their stats and unlocking new abilities. Here's how the experience and leveling system works:

# Experience Points (XP):
Brutes earn XP by participating in combat. The amount of XP earned depends on the outcome of the battle.
XP is gained for both winning and losing battles, but winning typically yields more XP.
Brutes accumulate XP over time, progressing towards the next level.

# Leveling Up:
Each Brute has a current level, indicating its overall strength and progression.
The XP required to reach the next level increases progressively, making it more challenging to level up as the Brute advances:

**XP for Next Level = Base XP×Level**

...

This means that to reach level 10 starting from level 1 a player needs to go through 30 combats approximately

When a Brute reaches the required XP threshold for the next level, it levels up.
Upon leveling up, the Brute's stats (such as strength/defense/and health) increase according to the player's choice (not implemented yet), making it more powerful in combat, and unlocking the strategical aspect in the game of what to choose (health/defense/strength).
Additionally, leveling up may unlock the ability for the Brute to acquire new special abilities, enhancing its capabilities further.

# Example:
Suppose a Brute starts at level 1 with 0 XP.
After winning several battles, the Brute accumulates enough XP to reach level 2.
At level 2, the Brute's stats improve, making it stronger and more resilient in combat.
Additionally, the Brute may unlock the ability to acquire new abilities, allowing the player to further customize its abilities and play style.


## Game Flow:
Creating a Brute: Players can create Brutes with unique names(by minting NFTs). Each Brute starts with base stats and no abilities.
Combat: Players can initiate combat between their Brutes. Combat is resolved based on Brute stats, and the winner gains experience points.
Leveling Up: As Brutes gain experience, they level up, improving their stats and unlocking the ability to acquire new abilities.
Acquiring Abilities: Players can gain special abilities for their Brutes. Abilities enhance certain stats(implemented) or provide unique effects in combat(not implemented yet).
Special Abilities: Brutes can acquire special abilities that grant additional powers or effects in combat. These abilities unlock at specific levels and require certain prerequisites.


## Example Scenario:
Creating a Brute: Player A creates a Brute named "Brawler."
Combat: Player A's Brawler engages in combat with Player B's Brute. The winner gains experience points based on the outcome.
Leveling Up: As the Brawler gains experience, it levels up, improving its stats.
Acquiring Abilities: For example, at level 5, the Brawler unlocks the ability to acquire special powers. Player A assigns the "Berserker" ability, which increases the Brawler's strength by 10 points.
Special Abilities: At level 10, the Brawler unlocks the "The Tank" ability, which grants a boost to health points during combat.

## Aspects and Ideas to add later on:

# Social Features:
Social Features: Add social features like leaderboards, clans, or the ability to challenge friends' brutes to enhance community interaction.

## Conclusion:
The Brute Game contract provides an engaging gaming experience where players can create, customize, and battle with their virtual characters, the Brutes. By gaining experience, leveling up, and acquiring special abilities, players can enhance their Brutes and compete in exciting combat scenarios.