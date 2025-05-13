-- Eric Gonzalez
-- CMPM 121 - Solitaire
-- 4-18-25
io.stdout:setvbuf("no")

math.randomseed(os.time())

require "card"
require "grabber"
require "stack"

function love.load()
  love.window.setMode(1440, 860)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.window.setTitle("Real Solitaire This Time")
  
  drawCard = love.audio.newSource("sfx/drawCard.mp3", "static")
  shuffleCard = love.audio.newSource("sfx/shuffleCard.mp3", "static")
  gameWon = love.audio.newSource("sfx/gameWon.mp3", "static")
  
  grabber = GrabberClass:new()
  cardTable = {}

  gameActive = true
  muted = false
  
  suits = {
    [1] = "Club",
    [2] = "Diamond",
    [3] = "Heart",
    [4] = "Spade"
    }
    
  values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
  
  --put all cards in one table and put them visually on top of each other
  for i = 1, #suits do
    for j = 1, #values do
      table.insert(cardTable, CardClass:new(100, 100, suits[i], values[j]))
    end
  end

  --shuffle
  shuffle(cardTable)
  
  --make the suit piles
  heartPile = StackClass:new(1200, 100)
  diamondPile = StackClass:new(1200, 270)
  clubPile = StackClass:new(1200, 440)
  spadePile = StackClass:new(1200, 610)
  
  heartPile.suit = "Heart"
  diamondPile.suit = "Diamond"
  clubPile.suit = "Club"
  spadePile.suit = "Spade"
  
  
  suitPiles = {
    heartPile,
    diamondPile,
    clubPile,
    spadePile
  }
  
  for _, pile in ipairs(suitPiles) do
    pile.bottomBound = pile.y + 140
    pile.isPile = true
  end
  
  --make the tableaus
  tableauOne = StackClass:new(250, 100)
  tableauTwo = StackClass:new(375, 100)
  tableauThree = StackClass:new(500, 100)
  tableauFour = StackClass:new(625, 100)
  tableauFive = StackClass:new(750, 100)
  tableauSix = StackClass:new(875, 100)
  tableauSeven = StackClass:new(1000, 100)
  
  tableaus = {
    tableauOne,
    tableauTwo,
    tableauThree,
    tableauFour,
    tableauFive,
    tableauSix,
    tableauSeven
    }
  
  k = 1 
  for i, tableau in ipairs(tableaus) do
    for j = 1, i do
      tableau:addCard(cardTable[k])
      k = k + 1
    end
    tableau:flipTopCardUp()
  end
  
  -- make the deck
  deckPile = StackClass:new(100, 100)
  for i=29, #cardTable do
    deckPile:addCard(cardTable[i], 0)
  end
  
  -- make the draw pile
  drawPile = StackClass:new(100, 250) 
  
  --make the discard pile (off screen because we don't need to see it)
  discardPile = StackClass:new(-200, 250)
end


function love.update()
  grabber:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
end


function love.draw()
  local smallText = love.graphics.newFont(15)
  love.graphics.setFont(smallText)
  
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.rectangle("fill", 100, 100, 90, 120)
  love.graphics.rectangle("fill", 100, 700, 100, 60)
  love.graphics.rectangle("fill", 250, 700, 100, 60)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Click here to draw more cards", 103, 137, 85, "center")
  smallText = love.graphics.newFont(20)
  love.graphics.setFont(smallText)
  love.graphics.printf("Reset", 102, 716, 95, "center")
  love.graphics.printf("Sound", 252, 716, 95, "center")
  
  local bigText = love.graphics.newFont(17)
  love.graphics.setFont(bigText)
  
  for _, tableau in ipairs(tableaus) do
    tableau:draw()
  end
  
  for _, pile in ipairs(suitPiles) do
    pile:draw()
  end
  
  love.graphics.setColor(1, 1, 1, 1) -- white text
  love.graphics.printf("Hearts", 1190, 145, 110, "center")
  love.graphics.printf("Diamonds", 1190, 315, 110, "center")
  love.graphics.printf("Clubs", 1190, 485, 110, "center")
  love.graphics.printf("Spades", 1190, 655, 110, "center")
  
  for _, card in ipairs(cardTable) do
    card:draw()
  end
  
  if not gameActive then
    grabber:draw()
  end
  
  if muted then
    love.graphics.line(250, 760, 350, 700)
  end
end


function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end

function toggleMute()
  muted = not muted
end


function playSFX(sound)
  if muted then
    return
  end
  
  if sound == "draw" then
    drawCard:play()
  elseif sound == "shuffle" then
    shuffleCard:play()
  elseif sound == "won" then
    gameWon:play()
  end
end


function placeOnTop(card)
  for i, c in ipairs(cardTable) do
    if c == card then
      table.remove(cardTable, i)
      table.insert(cardTable, card)
      break
    end
  end
end

--add the shuffling from class slides, credit to Zac Emerzian
function shuffle(cardTable)
  local cardCount = #cardTable
  for i = 1, cardCount do
    local randIndex = math.random(cardCount)
    local temp = cardTable[randIndex]
    cardTable[randIndex] = cardTable[cardCount]
    cardTable[cardCount] = temp
    cardCount = cardCount - 1
  end
  playSFX("shuffle")
  return cardTable
end

--when the mouse is clicked on top of the deck pile
function love.mousepressed(x, y)
  if love.mouse.getX() >= 100 and love.mouse.getX() <= 182 and love.mouse.getY() >= 100 and love.mouse.getY() <= 210 and gameActive == true then
    drawFromDeck()
  end
  
  if love.mouse.getX() >= 100 and love.mouse.getX() <= 200 and love.mouse.getY() >= 700 and love.mouse.getY() <= 760 then
    resetGame()
  end
  
  if love.mouse.getX() >= 250 and love.mouse.getX() <= 350 and love.mouse.getY() >= 700 and love.mouse.getY() <= 760 then
    toggleMute()
  end
  
end

function drawFromDeck()
  --if cards in draw pile, remove them from the draw pile and place into the discard pile
  if #drawPile.cards > 0 then
    for i = 1, #drawPile.cards do
      discardPile:addCard(drawPile.cards[1])
      drawPile:removeCard(1, 0)
    end
  end
  
  --if self.deckPile is empty, then iterate through discard pile, removing the last inserted card and adding it to self.deckPile
  if #deckPile.cards == 0 then
    for i = 1, #discardPile.cards do
      deckPile:addCard(discardPile.cards[#discardPile.cards], 0)
      deckPile.cards[#deckPile.cards]:flip()
      discardPile:removeCard(#discardPile.cards, 0)
    end
  end
  
  --add three cards to the drawPile if self.deckPile has 3 or more cards. If not, then just add as many cards as possible to the drawPile
  for i = 1, 3 do
    if #deckPile.cards > 0 then
      drawPile:addCard(deckPile.cards[#deckPile.cards])
      placeOnTop(drawPile.cards[#drawPile.cards])
      drawPile:flipTopCardUp()
      deckPile:removeCard(#deckPile.cards, 0)
    end
  end
  
  playSFX("draw")
end

function resetGame()
  grabber = GrabberClass:new()
  cardTable = {}
  
  gameActive = true
  
  suits = {
    [1] = "Club",
    [2] = "Diamond",
    [3] = "Heart",
    [4] = "Spade"
    }
    
  values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}
  
  --put all cards in one table and put them visually on top of each other
  for i = 1, #suits do
    for j = 1, #values do
      table.insert(cardTable, CardClass:new(100, 100, suits[i], values[j]))
    end
  end

  --shuffle
  shuffle(cardTable)
  
  --make the suit piles
  heartPile = StackClass:new(1200, 100)
  diamondPile = StackClass:new(1200, 270)
  clubPile = StackClass:new(1200, 440)
  spadePile = StackClass:new(1200, 610)
  
  heartPile.suit = "Heart"
  diamondPile.suit = "Diamond"
  clubPile.suit = "Club"
  spadePile.suit = "Spade"
  
  
  suitPiles = {
    heartPile,
    diamondPile,
    clubPile,
    spadePile
  }
  
  for _, pile in ipairs(suitPiles) do
    pile.bottomBound = pile.y + 140
    pile.isPile = true
  end
  
  --make the tableaus
  tableauOne = StackClass:new(250, 100)
  tableauTwo = StackClass:new(375, 100)
  tableauThree = StackClass:new(500, 100)
  tableauFour = StackClass:new(625, 100)
  tableauFive = StackClass:new(750, 100)
  tableauSix = StackClass:new(875, 100)
  tableauSeven = StackClass:new(1000, 100)
  
  tableaus = {
    tableauOne,
    tableauTwo,
    tableauThree,
    tableauFour,
    tableauFive,
    tableauSix,
    tableauSeven
    }
  
  k = 1 
  for i, tableau in ipairs(tableaus) do
    for j = 1, i do
      tableau:addCard(cardTable[k])
      k = k + 1
    end
    tableau:flipTopCardUp()
  end
  
  -- make the deck
  deckPile = StackClass:new(100, 100)
  for i=29, #cardTable do
    deckPile:addCard(cardTable[i], 0)
  end
  
  -- make the draw pile
  drawPile = StackClass:new(100, 250) 
  
  --make the discard pile (off screen because we don't need to see it)
  discardPile = StackClass:new(-200, 250)
end

  