-- Eric Gonzalez
-- CMPM 121 - Solitaire
-- 4-18-25
io.stdout:setvbuf("no")

math.randomseed(os.time())

require "card"
require "grabber"

function love.load()
  love.window.setMode(1440, 860)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  love.window.setTitle("I can move cards but that's about it :(")
  
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

  --startup the tableau piles
  --tableau(cardTable)
  --still need to implement, probably in some sort of stack class
  
end

function love.update()
  grabber:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
end

function love.draw()
  
  local bigText = love.graphics.newFont(20)
  love.graphics.setFont(bigText)
  
  --make areas to place the finished cards/piles
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.rectangle("fill", 1200, 80, 110, 150, 6, 6)
  love.graphics.rectangle("fill", 1200, 250, 110, 150, 6, 6)
  love.graphics.rectangle("fill", 1200, 420, 110, 150, 6, 6)
  love.graphics.rectangle("fill", 1200, 590, 110, 150, 6, 6)
  
  love.graphics.setColor(1, 1, 1, 1) -- white text
  love.graphics.printf("Hearts", 1200, 70 + 150/2, 110, "center")
  love.graphics.printf("Diamonds", 1200, 236 + 150/2, 110, "center")
  love.graphics.printf("Clubs", 1200, 407 + 150/2, 110, "center")
  love.graphics.printf("Spades", 1200, 577 + 150/2, 110, "center")
  
  for _, card in ipairs(cardTable) do
    card:draw() --card.draw(card)
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

function placeOnTop(card)
  for i, c in ipairs(cardTable) do
    if c == card then
      table.remove(cardTable, i)
      table.insert(cardTable, card)
      break
    end
  end
end

--add the shuffling from class slides
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