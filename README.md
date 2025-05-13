# CMPM-121-Solitaire

<h2>Programming Patterns:</h2>

I used various programming patterns to implement solitaire. All of these programming patterns listed are found in our course textbook:

- Commands - I used these to implment grabbing and releasing of cards.
- Update method - I used this to make sure that my observer (for checking if my mouse was over a card) was happening every frame.
- State - I used this to move between distinct card states using enums. This allowed me to more easily implement logic for when the card was in a grabbed state, idle state, etc.

<h2>Peer Feedback:</h2>

The people who gave me feedback are Andy Netwon, Ayush Bandopadhyay, and Cassian Jones. They all gave very similar feedback. They all said that overall, my code looks solid and they were able to understand what it does. They said that I chose reasonable variable names and had a good file structure too. For suggestions, they said that I could try to find a way to incorporate some of the deck.lua functionality into stack.lua, which I ended up doing and it worked out quite nicely. They also said that I could try to add a few more comments on the chunkier parts of the code. I took this advice when implementing the grabbing of card stacks in grabber.lua, which clears up what each section of the function is doing.

<h2>Postmortem:</h2>

This was my plan for addressing the pain points of the first go around: "Next time, I will implement functionality for allowing stacks to be moved and will also prevent invalid moves. The most major code style improvement I need to make is seeing where I can write my code more efficiently. What I mean is that there are parts of my code where I can use loops to cut down on the number of lines I need to write. I should also put all of my tableaus in a table, all of my win piles in a table, and so on. This would allow me to more easily parse through the tables and call functions on them in a loop. On a similar note, I think it's possible for me to put my code for my deck class into my stack class, and then just use inheritance for the structure. This improvement would remove an unnecessary file."

Here's what I did: To clarify, I have made the card stacks moveable and have also ensured that the player can only make valid moves. I also added the reset button and win screen. I also added sound effects for the point of extra credit. In addition to these functionality additions, I also refactored many areas of my code. I restructured how I was handling tableaus in main.lua and grabber.lua, and ended up saving over 150 lines of code. I think the code looks much more readable now, and the efficiency of my program has improved as a result of these changes. I also removed deck.lua completely and consolidated it into stack.lua. Overall, my refactoring efforts were very successful as the program structure is more robust and I was able to save many lines of code.

<h2>Assets</h2>
- Sprites: https://screamingbrainstudios.itch.io/poker-pack <br>
- Music: There is no background music. <br>
- SFX: All sound effects are from <a href = "https://pixabay.com/users/freesound_community-46691455/"> freesound_community
