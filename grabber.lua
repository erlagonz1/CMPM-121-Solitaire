
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  grabber.heldObject = {}
  grabber.grabOffset = nil -- so we can click on the card without the card teleporting to our mouse
  
  grabber.tempStack = nil -- so we can keep track of where the card previously was in case of an invalid move
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  if gameActive == false then
    return
  end
  
  if #self.heldObject > 0 then
     for i, card in ipairs(self.heldObject) do -- this should move all of the cards in the tempStack
       card.position.x = self.currentMousePos.x - self.grabOffset.x
       card.position.y = self.currentMousePos.y - self.grabOffset.y + ((i - 1) * 30)
     end
  end
  

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
  
  local card = nil
  
  -- make sure that the card that they tried to grab is a valid one to be grabbed
  for i = #cardTable, 1, -1 do
    card = cardTable[i]
    if card:checkWithinBounds(self.grabPos) and card.faceUp == true then
      if drawPile:contains(card) and card ~= drawPile.cards[#drawPile.cards] then  -- if the drawpile has the card then don't let the player grab the bottom ones
        return
      end
      self.grabOffset = self.currentMousePos - card.position
      break
    end
    if i == 1 then
      return
    end
  end
  
  local tableauIndex = nil
  
  -- find out if the card is in a tableau and track the index if it is
  for _, tableau in ipairs(tableaus) do  
    if tableau:contains(card) then
      self.tempStack = tableau
      tableauIndex = tableau:contains(card)
    end
  end
     
  if tableauIndex then  --if the card is inside of a tableau then add that card and all the ones below it to the self.heldObject table
    for i = tableauIndex, #self.tempStack.cards do
      table.insert(self.heldObject, self.tempStack.cards[i])
    end
  else  -- if not in a tableau, then it is either in a win pile or the draw pile
    for _, pile in ipairs(suitPiles) do
      if pile:contains(card) then
        self.tempStack = pile
        table.insert(self.heldObject, self.tempStack.cards[self.tempStack:contains(card)])  -- adds the last card of the pile to the self.heldObject table
      end
    end
    if drawPile:contains(card) then
      self.tempStack = drawPile
      table.insert(self.heldObject, self.tempStack.cards[self.tempStack:contains(card)])  -- adds the last card of the pile to the self.heldObject table
    end
  end
  
  --update card attributes to grabbed and make sure they are displayed correctly, also remove the cards from the tempStack
  for i = 1, #self.heldObject, 1 do
    self.heldObject[i].state = CARD_STATE.GRABBED
    placeOnTop(self.heldObject[i])
    if #self.heldObject == 1 then
      self.tempStack:removeCard(#self.tempStack.cards, 0)
    elseif #self.heldObject >= 1 then
      self.tempStack:removeCard(#self.tempStack.cards)
    end
  end
end


function GrabberClass:release()

  if #self.heldObject == 0 then
    self.grabPos = nil
    return
  end
  
  local halfCardWidth = 46
  local halfCardheight = 55
  
  local moved = false
  
  --if the card is released in a tableau
  for _, tableau in ipairs(tableaus) do
    if self.heldObject[1].position.x + halfCardWidth >= tableau.leftBound and self.heldObject[1].position.x + halfCardWidth <= tableau.rightBound and self.heldObject[1].position.y + halfCardheight <= tableau.bottomBound and self.heldObject[1].position.y + halfCardheight >= tableau.topBound then
      if self:isTableauPlacementValid(tableau) then
        for _, card in ipairs(self.heldObject) do
          tableau:addCard(card)
        end
        moved = true
        break
      end
    end
  end
  
  --if the card is released in a end pile
  for _, pile in ipairs(suitPiles) do
    if self.heldObject[1].position.x + halfCardWidth >= pile.leftBound and self.heldObject[1].position.x + halfCardWidth <= pile.rightBound and self.heldObject[1].position.y + halfCardheight <= pile.bottomBound and self.heldObject[1].position.y + halfCardheight >= pile.topBound then
      if self:isPilePlacementValid(pile) then
        for _, card in ipairs(self.heldObject) do
          pile:addCard(card)
        end
        moved = true
        self:isGameWon()
        break
      end
    end
  end
  
  if moved == false then
    if self.tempStack then --temporary, remove this if (leave the statement though) once finished implementing the concept that random clicks should not trigger the grab function
      for _, card in ipairs(self.heldObject) do
        self.tempStack:addCard(card)
      end
    end
  end
  
  -- ensure the top card of each tableau is always flipped up
  for _, tableau in ipairs(tableaus) do
    tableau:flipTopCardUp()
  end
  for _, pile in ipairs(suitPiles) do
    pile:flipTopCardUp()
  end
  drawPile:flipTopCardUp()

  self.heldObject = {}
  
  for _, card in ipairs(self.heldObject) do
    card.state = CARD_STATE.IDLE
  end

  self.grabPos = nil
  self.grabOffset = nil
  self.tempStack = nil
  moved = false
end


function GrabberClass:isTableauPlacementValid(tableau)
  if #self.heldObject < 1 or tableau == nil then
    return false
  end
  
  if #tableau.cards == 0 then
    if self.heldObject[1].value == 13 then
      return true
    else
      return false
    end
  end
  
  -- if the held object's value +1 = the tableau's last card's value and the held object's color != to the tableau's last card's color, then true, otherwise false
  if self.heldObject[1].value + 1 == tableau.cards[#tableau.cards].value and self.heldObject[1].color ~= tableau.cards[#tableau.cards].color then
    return true
  else
    return false
  end
end


function GrabberClass:isPilePlacementValid(pile)
  if #self.heldObject ~= 1 then
    return false
  end
  
  if self.heldObject[1].suit ~= pile.suit then
    return false
  end
  
  if #pile.cards == 0 then
    if self.heldObject[1].value == 1 then
      return true
    else
      return false
    end
  end
  
  if self.heldObject[1].value == pile.cards[#pile.cards].value + 1 then
    return true
  else
    return false
  end
end


function GrabberClass:isGameWon()
  for _, pile in ipairs(suitPiles) do
    if #pile.cards < 13 then
      return
    end
  end
  print("Game Won!")
  gameActive = false
  playSFX("won")
end

function GrabberClass:draw()
  love.graphics.setColor(1, 1, 0) -- yellow text
  love.graphics.setFont(love.graphics.newFont(150))
  love.graphics.printf("You Won!", 215, 340, 1000, "center")
end




