
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
      
      if tableauOne and tableauOne:contains(card) then
        tableauOne:removeCard(tableauOne:contains(card))
      end
      
      if tableauTwo and tableauTwo:contains(card) then
        tableauTwo:removeCard(tableauTwo:contains(card))
      end
      
      if tableauThree and tableauThree:contains(card) then
        tableauThree:removeCard(tableauThree:contains(card))
      end
      
      if tableauFour and tableauFour:contains(card) then
        tableauFour:removeCard(tableauFour:contains(card))
      end
      
      if tableauFive and tableauFive:contains(card) then
        tableauFive:removeCard(tableauFive:contains(card))
      end
      
      if tableauSix and tableauSix:contains(card) then
        tableauSix:removeCard(tableauSix:contains(card))
      end
      
      if tableauSeven and tableauSeven:contains(card) then
        tableauSeven:removeCard(tableauSeven:contains(card))
      end
      
      if heartPile and heartPile:contains(card) then
        heartPile:removeCard(heartPile:contains(card), 0)
      end
      
      if diamondPile and diamondPile:contains(card) then
        diamondPile:removeCard(diamondPile:contains(card), 0)
      end
      
      if clubPile and clubPile:contains(card) then
        clubPile:removeCard(clubPile:contains(card), 0)
      end
      
      if spadePile and spadePile:contains(card) then
        spadePile:removeCard(spadePile:contains(card), 0)
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
  if self.heldObject.position.x + 46 >= tableauOne.leftBound and self.heldObject.position.x + 46 <= tableauOne.rightBound and self.heldObject.position.y + 55 <= tableauOne.bottomBound and self.heldObject.position.y + 55 >= tableauOne.topBound then
    tableauOne:addCard(self.heldObject)
  elseif self.heldObject.position.x + 46 >= tableauTwo.leftBound and self.heldObject.position.x + 46 <= tableauTwo.rightBound and self.heldObject.position.y + 55 <= tableauTwo.bottomBound and self.heldObject.position.y + 55 >= tableauTwo.topBound then
    tableauTwo:addCard(self.heldObject)
  elseif self.heldObject.position.x + 46 >= tableauThree.leftBound and self.heldObject.position.x + 46 <= tableauThree.rightBound and self.heldObject.position.y + 55 <= tableauThree.bottomBound and self.heldObject.position.y + 55 >= tableauThree.topBound then
    tableauThree:addCard(self.heldObject)
  elseif self.heldObject.position.x + 46 >= tableauFour.leftBound and self.heldObject.position.x + 46 <= tableauFour.rightBound and self.heldObject.position.y + 55 <= tableauFour.bottomBound and self.heldObject.position.y + 55 >= tableauFour.topBound then
    tableauFour:addCard(self.heldObject)
  elseif self.heldObject.position.x + 46 >= tableauFive.leftBound and self.heldObject.position.x + 46 <= tableauFive.rightBound and self.heldObject.position.y + 55 <= tableauFive.bottomBound and self.heldObject.position.y + 55 >= tableauFive.topBound then
    tableauFive:addCard(self.heldObject)
  elseif self.heldObject.position.x + 46 >= tableauSix.leftBound and self.heldObject.position.x + 46 <= tableauSix.rightBound and self.heldObject.position.y + 55 <= tableauSix.bottomBound and self.heldObject.position.y + 55 >= tableauSix.topBound then
    tableauSix:addCard(self.heldObject)
  elseif self.heldObject.position.x + 46 >= tableauSeven.leftBound and self.heldObject.position.x + 46 <= tableauSeven.rightBound and self.heldObject.position.y + 55 <= tableauSeven.bottomBound and self.heldObject.position.y + 55 >= tableauSeven.topBound then
    tableauSeven:addCard(self.heldObject)
    
  --if the card is released in a end pile
  elseif self.heldObject.position.x + 46 >= heartPile.leftBound and self.heldObject.position.x + 46 <= heartPile.rightBound and self.heldObject.position.y + 55 <= heartPile.bottomBound and self.heldObject.position.y + 55 >= heartPile.topBound then
    heartPile:addCard(self.heldObject, 0)
  elseif self.heldObject.position.x + 46 >= diamondPile.leftBound and self.heldObject.position.x + 46 <= diamondPile.rightBound and self.heldObject.position.y + 55 <= diamondPile.bottomBound and self.heldObject.position.y + 55 >= diamondPile.topBound then
    diamondPile:addCard(self.heldObject, 0)
  elseif self.heldObject.position.x + 46 >= clubPile.leftBound and self.heldObject.position.x + 46 <= clubPile.rightBound and self.heldObject.position.y + 55 <= clubPile.bottomBound and self.heldObject.position.y + 55 >= clubPile.topBound then
    clubPile:addCard(self.heldObject, 0)
  elseif self.heldObject.position.x + 46 >= spadePile.leftBound and self.heldObject.position.x + 46 <= spadePile.rightBound and self.heldObject.position.y + 55 <= spadePile.bottomBound and self.heldObject.position.y + 55 >= spadePile.topBound then
    spadePile:addCard(self.heldObject, 0)
  
  --if the card is released in the draw pile
  elseif self.heldObject.position.x + 46 >= deckStack.drawPile.leftBound and self.heldObject.position.x + 46 <= deckStack.drawPile.rightBound and self.heldObject.position.y + 55 <= deckStack.drawPile.bottomBound and self.heldObject.position.y + 55 >= deckStack.drawPile.topBound then
    deckStack.drawPile:addCard(self.heldObject)
  end
  
  
  tableauOne:flipTopCardUp()
  tableauTwo:flipTopCardUp()
  tableauThree:flipTopCardUp()
  tableauFour:flipTopCardUp()
  tableauFive:flipTopCardUp()
  tableauSix:flipTopCardUp()
  tableauSeven:flipTopCardUp()
  
  heartPile:flipTopCardUp()
  diamondPile:flipTopCardUp()
  clubPile:flipTopCardUp()
  spadePile:flipTopCardUp()
  
  deckStack.drawPile:flipTopCardUp()

  self.heldObject.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.grabPos = nil
  self.grabOffset = nil
end