
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2,
}

function CardClass:new(xPos, yPos, faceImage)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  
  card.backImage = love.graphics.newImage("Sprites/CardBack.png")
  card.frontImage = love.graphics.newImage(faceImage)
  card.image = card.backImage
  card.faceUp = false
  
  card.size = Vector(card.image:getWidth(), card.image:getHeight())
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  -- drawing a shadow when cards are not idle, credit to Zac Emerzian (showed us this in class)
  if self.state ~= CARD_STATE.IDLE then
    love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(self.image, self.position.x, self.position.y)
  
  --love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
    
  isMouseOver = self:checkWithinBounds(grabber.currentMousePos)
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
  --print(tostring(self.state))
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