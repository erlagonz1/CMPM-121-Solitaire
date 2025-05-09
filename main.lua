-- Eric Gonzalez
-- CMPM 121 - Solitaire
-- 4-18-25
io.stdout:setvbuf("no")

math.randomseed(os.time())

require "card"
require "grabber"
require "stack"
require "deck"

function love.load()
  love.window.setMode(1440, 860)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.window.setTitle("Pseudo Solitaire v1.5")
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  suits = {
    [1] = "Club",
    [2] = "Diamond",
    [3] = "Heart",
    [4] = "Spade"
    }
    
  values = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13
  }
  
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
  
  suitPiles = {
    heartPile,
    diamondPile,
    clubPile,
    spadePile
  }
  
  for _, pile in ipairs(suitPiles) do
    pile.bottomBound = pile.y + 140
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
  deckStack = DeckClass:new(100, 100)
  for i=29, #cardTable do
    deckStack:addCard(cardTable[i])
  end
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
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf("Click here to draw more cards", 103, 137, 85, "center")
  
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
    card:draw() --card.draw(card)
  end
  
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y))
end


function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
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
    return cardTable
end

--when the mouse is clicked on top of the deck pile
function love.mousepressed(x, y)
  if love.mouse.getX() >= 100 and love.mouse.getX() <= 182 and love.mouse.getY() >= 100 and love.mouse.getY() <= 210 then
    deckStack:draw()
  end
end
  