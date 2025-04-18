# CMPM-121-Solitaire

<h2>Programming Patterns</h2>

I used various programming patterns to implement solitaire. All of these programming patterns listed are found in our course textbook:

- Commands - I used these to implment grabbing and releasing of cards.
- Observer - I used to this to check if my mouse was over a card.
- Update method - I used this to make sure that my observer (for checking if my mouse was over a card) was happening every frame.
- State - I used this to move between distinct card states using enums. This allowed me to more easily implement logic for when the card was in a grabbed state, idle state, etc.

<h2>Postmortem:</h2>

I did well making the cards move. I feel that the logic I used for it is pretty sound, especially how I make sure that the newest cards are visually on top of the other cards. I followed the same class structure/ file split that we did in class for moving objects, and I think this was a good choice because all of the code was modularized. For future projects, I would definitely repeat the process of making multiple lua files, each having its own class or a certain task that I want it to fulfill. This also made it easier to debug my program because I was able to quickly find which specific section of the code had errors. Next time, I think something I would do differently is think about more ways to make the program appear nicer. I would benefit from taking more time to read the lua documentation to implement better visuals for the game, rather than just having simple rectangles that have text saying where the cards are supposed to go. I would also try to structure my code to take even more of it outside of main.lua. Ideally, I would have less code in main.lua and try to make it so that it only has the load parameters plus a bunch of function calls. I think this would help for code readibility.

<h2>Assets</h2>
- Sprites: https://screamingbrainstudios.itch.io/poker-pack <br>
- Music: There is no background music. <br>
- SFX: There are no sound effects.
