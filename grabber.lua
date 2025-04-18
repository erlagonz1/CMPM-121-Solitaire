
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  -- NEW: we'll want to keep track of the object (ie. card) we're holding
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
    self.heldObject.position = self.currentMousePos - self.grabOffset --makes the card get picked up from our current mouse position
  end
  
  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then
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
  
  for i = #cardTable, 1, -1 do --puts the card in grab state and puts it as the newest entry in the table, making it visually above the other cards
    local card = cardTable[i]
    if card:checkWithinBounds(self.currentMousePos) then
      self.heldObject = card
      card.state = CARD_STATE.GRABBED
      placeOnTop(card)
      self.grabOffset = self.currentMousePos - card.position
      break
    end
  end
end


function GrabberClass:release()
  --print("RELEASE - ")

  if self.heldObject == nil then
    self.grabPos = nil
    return
  end

  self.heldObject.state = CARD_STATE.IDLE
  self.heldObject = nil
  self.grabPos = nil
  self.grabOffset = nil --reset our grab offset
end