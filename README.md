# Chicken Fight



## Basic Overview

* The player will start with an amount of money ($50, for example) and a single chicken to begin with.
* Starting the game will prompt the player with two choices: play or quit the program.
* By selecting play, a prompt to name the first chicken will appear; afterwards, they can bet any amount of money within their budget, whether it be $5 or all-in.
* Once the name and bet are decided, the chicken will fight another random chicken. Both chickens will have the same amount of health (not decided yet); however, damage dealt will be of a random value from a range (undecided, but could be 1-10 DMG).
* If the chicken's HP is 10, a knockout will be possible.
* Should the player win, they will receive their wagered amount, and a prompt to play again, open the store, or quit will appear.
* Should they lose, they will be notified that their starting chicken has perished in combat, and they will need to purchase a new chicken to keep playing if they have enough to buy another; otherwise, the program will automatically quit after telling the player they lost.
* Opening the store will allow the player to purchase a new chicken.
* Once a new chicken is bought, the store will automatically close and prompt the player to play again or quit.
* Playing again will repeat the aforementioned process.
* Wins will be tracked until the player is unable to play again due to financial issues or quits.



## Timeline

- Week 1 (11/16 - 11/22)
	- [ ] Finalize game rules → HP, damage range, betting mechanics, cost of chicken, naming chicken, etc.
	- [ ] Deciding how to store data
	- [ ] Creating the main outline for the game, including functionality like start, fight, reset, and end program
	- [x] Create the basic program structure and discuss a universal form of version control (GitHub)

- Week 2 (11/23 - 11/29)
	- [ ] Implement previously discussed functions into the program → naming  the chicken and placing bets/tracking budget
	- [ ] Create our damage functions and enemy generation
	- [ ] Build the fight system to track HP updates and a win-loss record
	- [ ] Create a shop system to purchase more chickens
	- [ ] Have a rough functioning version of the game working by the end of the week (11/29)

- Week 3 (11/30 - 12/7)
	- [ ] Clean up user prompts, menus, and the overall flow of the game
	- [ ] Potential implementation of ASCII art of chickens and a health bar
	- [ ] Improve user input validation and error handling
	- [ ] Merge all code on GitHub
	- [ ] Carry out testing of the game to verify functionality
	- [ ] Final debugging and project presentation preparation
