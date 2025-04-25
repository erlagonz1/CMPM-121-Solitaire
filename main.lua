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
  love.window.setTitle("Pseudo Solitaire")
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  suits = {
    [1] = "Club",
    [2] = "Diamond",
    [3] = "Heart",
    [4] = "Spade"
    }
    
  values = {
    [1] = "Ace",
    [2] = "Two",
    [3] = "Three",
    [4] = "Four",
    [5] = "Five",
    [6] = "Six",
    [7] = "Seven",
    [8] = "Eight",
    [9] = "Nine",
    [10] = "Ten",
    [11] = "Jack",
    [12] = "Queen",
    [13] = "King"
  }
  
  --put all cards in one table and put them visually on top of each other
  for i = 1, #suits do
    for j = 1, #values do
      table.insert(cardTable, CardClass:new(100, 100, "Sprites/" .. suits[i] .. values[j] .. ".png"))
    end
  end

  --shuffle
  shuffle(cardTable)
  
  --make the win piles
  heartPile = StackClass:new(1200, 100)
  heartPile.bottomBound = heartPile.y + 140
  
  diamondPile = StackClass:new(1200, 270)
  diamondPile.bottomBound = diamondPile.y + 140
  
  clubPile = StackClass:new(1200, 440)
  clubPile.bottomBound = clubPile.y + 140
  
  spadePile = StackClass:new(1200, 610)
  spadePile.bottomBound = spadePile.y + 140
  
  --make the tableaus
  tableauOne = StackClass:new(250, 100)
  tableauOne:addCard(cardTable[1])
  tableauOne:flipTopCardUp()
  
  tableauTwo = StackClass:new(375, 100)
  tableauTwo:addCard(cardTable[2])
  tableauTwo:addCard(cardTable[3])
  tableauTwo:flipTopCardUp()
  
  tableauThree = StackClass:new(500, 100)
  tableauThree:addCard(cardTable[4])
  tableauThree:addCard(cardTable[5])
  tableauThree:addCard(cardTable[6])
  tableauThree:flipTopCardUp()
  
  tableauFour = StackClass:new(625, 100)
  tableauFour:addCard(cardTable[7])
  tableauFour:addCard(cardTable[8])
  tableauFour:addCard(cardTable[9])
  tableauFour:addCard(cardTable[10])
  tableauFour:flipTopCardUp()
  
  tableauFive = StackClass:new(750, 100)
  tableauFive:addCard(cardTable[11])
  tableauFive:addCard(cardTable[12])
  tableauFive:addCard(cardTable[13])
  tableauFive:addCard(cardTable[14])
  tableauFive:addCard(cardTable[15])
  tableauFive:flipTopCardUp()
  
  tableauSix = StackClass:new(875, 100)
  tableauSix:addCard(cardTable[16])
  tableauSix:addCard(cardTable[17])
  tableauSix:addCard(cardTable[18])
  tableauSix:addCard(cardTable[19])
  tableauSix:addCard(cardTable[20])
  tableauSix:addCard(cardTable[21])
  tableauSix:flipTopCardUp()
  
  tableauSeven = StackClass:new(1000, 100)
  tableauSeven:addCard(cardTable[22])
  tableauSeven:addCard(cardTable[23])
  tableauSeven:addCard(cardTable[24])
  tableauSeven:addCard(cardTable[25])
  tableauSeven:addCard(cardTable[26])
  tableauSeven:addCard(cardTable[27])
  tableauSeven:addCard(cardTable[28])
  tableauSeven:flipTopCardUp()
  
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
  
  tableauOne:draw()
  tableauTwo:draw()
  tableauThree:draw()
  tableauFour:draw()
  tableauFive:draw()
  tableauSix:draw()
  tableauSeven:draw()
  
  heartPile:draw()
  diamondPile:draw()
  clubPile:draw()
  spadePile:draw()
  
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
  