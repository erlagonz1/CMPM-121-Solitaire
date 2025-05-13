# CMPM-121-Solitaire

<h2>Programming Patterns</h2>

I used various programming patterns to implement solitaire. All of these programming patterns listed are found in our course textbook:

- Commands - I used these to implment grabbing and releasing of cards.
- Observer - I used to this to check if my mouse was over a card.
- Update method - I used this to make sure that my observer (for checking if my mouse was over a card) was happening every frame.
- State - I used this to move between distinct card states using enums. This allowed me to more easily implement logic for when the card was in a grabbed state, idle state, etc.

<h2>Postmortem:</h2>

This was my plan for addressing the pain points of the first go around: "Next time, I will implement functionality for allowing stacks to be moved and will also prevent invalid moves. The most major code style improvement I need to make is seeing where I can write my code more efficiently. What I mean is that there are parts of my code where I can use loops to cut down on the number of lines I need to write. I should also put all of my tableaus in a table, all of my win piles in a table, and so on. This would allow me to more easily parse through the tables and call functions on them in a loop. On a similar note, I think it's possible for me to put my code for my deck class into my stack class, and then just use inheritance for the structure. This improvement would remove an unnecessary file. Lastly, I also need to work on declaring mroe variables to make my logic more clear. For example, I could make a variable called "whiteColor" equal to a able with all 1s. Then whenever I set the color of something to white, I could just use my whiteColor variable rather than inputting the numbers. These kinds of improvements would make my code more readable."

Here's what I did: To clarify, I am still working on the functionality for making card stacks moveable as well as only allowing valid moves. I am also working on adding in the reset button and win screen. What I did do is sucessfully refactor many areas of my code. I restructured how I was handling tableaus in main.lua and grabber.lua, and ended up saving over 150 lines of code. I think the code looks much more readable now, and the efficiency of my program has improved as a result of these changes. I still plan on doing a little more refactoring, such as changing some offset values into variables and other small things of that nature. If possible, I will also try making my deck.lua to be under my stack class.

<h2>Assets</h2>
- Sprites: https://screamingbrainstudios.itch.io/poker-pack <br>
- Music: There is no background music. <br>
- SFX: All sound effects are from [freesound_community](https://pixabay.com/users/freesound_community-46691455/) on pixabay.com
