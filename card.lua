
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
}

function CardClass:new(xPos, yPos, suit, value)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.state = CARD_STATE.IDLE
  
  card.suit = suit
  card.value = value
  card.color = "not assigned"
  
  if card.suit == "Heart" or card.suit == "Diamond" then
    card.color = "red"
  else
    card.color = "black"
  end
  
  card.backImage = love.graphics.newImage("Sprites/CardBack.png")
  card.frontImage = love.graphics.newImage("Sprites/" .. card.suit .. tostring(card.value) .. ".png")
  card.image = card.backImage
  card.faceUp = false
  
  card.size = Vector(card.image:getWidth(), card.image:getHeight())
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.image, self.position.x, self.position.y)
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
    
  isMouseOver = self:checkWithinBounds(grabber.currentMousePos)
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function CardClass:checkWithinBounds(object)
  return object.x > self.position.x and
    object.x < self.position.x + self.size.x and
    object.y > self.position.y and
    object.y < self.position.y + self.size.y
end
    
function CardClass:flip()
  self.faceUp = not self.faceUp
  self.image = self.faceUp and self.frontImage or self.backImage
end