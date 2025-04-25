# CMPM-121-Solitaire

<h2>Programming Patterns</h2>

I used various programming patterns to implement solitaire. All of these programming patterns listed are found in our course textbook:

- Commands - I used these to implment grabbing and releasing of cards.
- Observer - I used to this to check if my mouse was over a card.
- Update method - I used this to make sure that my observer (for checking if my mouse was over a card) was happening every frame.
- State - I used this to move between distinct card states using enums. This allowed me to more easily implement logic for when the card was in a grabbed state, idle state, etc.

<h2>Postmortem:</h2>

I did well making the cards move. I think my logic for it is pretty sound, especially how I make sure that the newest cards are visually on top of the other cards. I followed the same class structure/ file split that we did in class for moving objects, and I think this was a good choice because all of the code was modularized. For future projects, I would definitely repeat the process of making multiple lua files, each having its own class or a certain task that I want it to fulfill. This also made it easier to debug my program because I was able to quickly find which specific section of the code had errors. Next time, I will implement functionality for allowing stacks to be moved and will also prevent invalid moves. The most major code style improvement I need to make is seeing where I can write my code more efficiently. What I mean is that there are parts of my code where I can use loops to cut down on the number of lines I need to write. I should also put all of my tableaus in a table, all of my win piles in a table, and so on. This would allow me to more easily parse through the tables and call functions on them in a loop. On a similar note, I think its possible for me to put my code for my deck class into my stack class, and then just use inheritance for the structure. This improvement would remove an unnecessary file. Lastly, I also need to work on declaring mroe variables to make my logic more clear. For example, I could make a variable called "whiteColor" equal to a able with all 1s. Then whenever I set the color of something to white, I could just use my whiteColor variable rather than inputting the numbers. These kinds of improvements would make my code more readable.

<h2>Assets</h2>
- Sprites: https://screamingbrainstudios.itch.io/poker-pack <br>
- Music: There is no background music. <br>
- SFX: There are no sound effects.
