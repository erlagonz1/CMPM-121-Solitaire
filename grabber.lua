
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  grabber.heldObject = nil
  grabber.grabOffset = nil --so we can click on the card without the card teleporting to our mouse
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  if self.heldObject then
    self.heldObject.position = self.currentMousePos - self.grabOffset --makes the card get picked up from my current mouse position, not snap to my mouse
  end
  

  if love.mouse.isDown(1) and self.grabPos == nil then -- Click (just the first frame)
    self:grab()
  end
  
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end  
end


function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  --print("GRAB - " .. tostring(self.grabPos))
  
  for i = #cardTable, 1, -1 do --puts the card in grab state and puts it as the newest entry in the overall card table, making it visually above the other cards
    local card = cardTable[i]
    if card:checkWithinBounds(self.currentMousePos) then
      self.heldObject = card
      card.state = CARD_STATE.GRABBED
      placeOnTop(card)
      self.grabOffset = self.currentMousePos - card.position
    
    
        for i, tableau in ipairs(tableaus) do
          if tableau and tableau:contains(card) then
            tableau:removeCard(tableau:contains(card))
            break
          end
        end
      
      for _, pile in ipairs(suitPiles) do
        if pile and pile:contains(card) then
          pile:removeCard(pile:contains(card), 0)
          break
        end
      end
      
      if deckStack and deckStack.drawPile:contains(card) then
        deckStack.drawPile:removeCard(deckStack.drawPile:contains(card))
      end
      
      break
    end
  end
end


function GrabberClass:release()

  if self.heldObject == nil then
    self.grabPos = nil
    return
  end
  
  --if the card is released in a tableau
  for _, tableau in ipairs(tableaus) do
    if self.heldObject.position.x + 46 >= tableau.leftBound and self.heldObject.position.x + 46 <= tableau.rightBound and self.heldObject.position.y + 55 <= tableau.bottomBound and self.heldObject.position.y + 55 >= tableau.topBound then
      tableau:addCard(self.heldObject)
    end
  end

  --if the card is released in a end pile
  for _, pile in ipairs(suitPiles) do
    if self.heldObject.position.x + 46 >= pile.leftBound and self.heldObject.position.x + 46 <= pile.rightBound and self.heldObject.position.y + 55 <= pile.bottomBound and self.heldObject.position.y + 55 >= pile.topBound then
      pile:addCard(self.heldObject, 0)
    end
  end

  --if the card is released in the draw pile
  if self.heldObject.position.x + 46 >= deckStack.drawPile.leftBound and self.heldObject.position.x + 46 <= deckStack.drawPile.rightBound and self.heldObject.position.y + 55 <= deckStack.drawPile.bottomBound and self.heldObject.position.y + 55 >= deckStack.drawPile.topBound then
    deckStack.drawPile:addCard(self.heldObject)
  end
  
  for _, tableau in ipairs(tableaus) do
    tableau:flipTopCardUp()
  end

  for _, pile in ipairs(suitPiles) do
    pile:flipTopCardUp()
  end
  
  deckStack.drawPile:flipTopCardUp()

  self.heldObject.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.grabPos = nil
  self.grabOffset = nil
end