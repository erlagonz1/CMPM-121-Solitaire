
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
  --grabber.heldObject = nil
  grabber.grabOffset = nil -- so we can click on the card without the card teleporting to our mouse
  
  grabber.prevStack = nil -- so we can keep track of where the card previously was in case of an invalid move
  grabber.tempStack = nil --so we can move stacks of cards at once
  grabber.active = true
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  if self.active == false then
    return
  end
  
  if #self.heldObject > 0 then
    
     for i, card in ipairs(self.heldObject) do -- this should move all of the cards in the tempStack
       card.position.x = self.currentMousePos.x - self.grabOffset.x
       card.position.y = self.currentMousePos.y - self.grabOffset.y + (i * 30)
     end
  end
--    self.heldObject.position = self.currentMousePos - self.grabOffset --makes the card get picked up from my current mouse position, not snap to my mouse
--  end
  

  if love.mouse.isDown(1) and self.grabPos == nil then -- Click (just the first frame)
    --make function called try grabbing
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
         print("cannot grab the non top card in the drawPile!")
         return
       end
       self.grabOffset = self.currentMousePos - card.position
       print("grab offset is " .. tostring(self.grabOffset.x) .. ", " .. tostring(self.grabOffset.y))
       break --maybe don't need this?
     end
     if i == 1 then
       print("did not grab a face up card")
       return
     end
   end
  
   local tableauIndex = nil
  
   -- find out if the card is in a tableau and track the index if it is
   for _, tableau in ipairs(tableaus) do  
     if tableau:contains(card) then
       self.tempStack = tableau
       tableauIndex = tableau:contains(card)
       print(tostring(tableauIndex) .. " is the tableauIndex")
     end
   end
      
   if tableauIndex then  --if the card is inside of a tableau then add that card and all the ones below it to the self.heldObject table
     for i = tableauIndex, #self.tempStack.cards do
       table.insert(self.heldObject, self.tempStack.cards[i])
     end
     print(tostring(#self.heldObject) .. " cards in self.heldObject")
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
  
   --keep track of previous stack in case the move is invalid and all the cards have to be added back.
   self.prevStack = self.tempStack

      --working code below
      
--  for i = #cardTable, 1, -1 do --puts the card in grab state and puts it as the newest entry in the overall card table, making it visually above the other cards
--    local card = cardTable[i]
--    if card:checkWithinBounds(self.grabPos) and card.faceUp == true then  --if the cursor is within the bounds of the card and it is face up
--      self.heldObject = card
--      card.state = CARD_STATE.GRABBED
--      placeOnTop(card)
--      self.grabOffset = self.currentMousePos - card.position
    
    
--      for _, tableau in ipairs(tableaus) do
--        if tableau and tableau:contains(card) then
--          self.prevStack = tableau
--          tableau:removeCard(tableau:contains(card))
--          break
--        end
--      end
      
--      for _, pile in ipairs(suitPiles) do
--        if pile and pile:contains(card) then
--          self.prevStack = pile
--          pile:removeCard(pile:contains(card), 0)
--          break
--        end
--      end
      
--      if drawPile and drawPile:contains(card) then
--        self.prevStack = drawPile
--        drawPile:removeCard(drawPile:contains(card))
--      end
      
--      break
--    end
--  end
  print(tostring(#self.heldObject) .. " cards in self.heldObject at the end of the grab function")
  print("grab function completed")
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
      else
        for _, card in ipairs(self.heldObject) do
          self.prevStack:addCard(card)
        end
        break
      end
    end
  end
  
  
--  for _, tableau in ipairs(tableaus) do
--    if self.heldObject.position.x + halfCardWidth >= tableau.leftBound and self.heldObject.position.x + halfCardWidth <= tableau.rightBound and self.heldObject.position.y + halfCardheight <= tableau.bottomBound and self.heldObject.position.y + halfCardheight >= tableau.topBound then
--      if self:isTableauPlacementValid(tableau) then
--        tableau:addCard(self.heldObject)
--        moved = true
--        break
--      else
--        self.prevStack:addCard(self.heldObject)
--        moved = true
--        break
--      end
--    end
--  end

  --if the card is released in a end pile
  for _, pile in ipairs(suitPiles) do
    if self.heldObject[1].position.x + halfCardWidth >= pile.leftBound and self.heldObject[1].position.x + halfCardWidth <= pile.rightBound and self.heldObject[1].position.y + halfCardheight <= pile.bottomBound and self.heldObject[1].position.y + halfCardheight >= pile.topBound then
      if self:isPilePlacementValid(pile) then
        for _, card in ipairs(self.heldObject) do
          pile:addCard(card)
        end
        moved = true
        --self:isGameWon()
        break
      else
        for _, card in ipairs(self.heldObject) do
          self.prevStack:addCard(card)
        end
        break
      end
    end
  end

--  --if the card is released in the draw pile
--  if self.heldObject.position.x + halfCardWidth >= drawPile.leftBound and self.heldObject.position.x + halfCardWidth <= drawPile.rightBound and self.heldObject.position.y + halfCardheight <= drawPile.bottomBound and self.heldObject.position.y + halfCardheight >= drawPile.topBound then
--    drawPile:addCard(self.heldObject)
--  end
  
  if moved == false then
    print("did not place in any valid position, invalid move")
    if self.prevStack then --temporary, remove this if (leave the statement though) once finished implementing the concept that random clicks should not trigger the grab function
      for _, card in ipairs(self.heldObject) do
        self.prevStack:addCard(card)
      end
    end
  end
  
  for _, tableau in ipairs(tableaus) do
    tableau:flipTopCardUp()
  end

  for _, pile in ipairs(suitPiles) do
    pile:flipTopCardUp()
  end
  
  drawPile:flipTopCardUp()
  
  -- for _, card in ipairs(self.heldObject) do
    -- card.state = CARD_STATE.IDLE
  -- end
  
  self.heldObject = {}
  print(tostring(#self.heldObject) .. " cards in self.heldObject at the end of the release function")
  for _, card in ipairs(self.heldObject) do
    card.state = CARD_STATE.IDLE
  end

  --self.heldObject.state = CARD_STATE.IDLE
  --self.heldObject = nil
  self.grabPos = nil
  self.grabOffset = nil
  self.prevStack = nil
  moved = false
end


function GrabberClass:isTableauPlacementValid(tableau)
  if #self.heldObject < 1 then
    return false
  end
  -- if the held object's value +1 = the tableau's last card's value and the held object's color != to the tableau's last card's color, then true, otherwise false
  if self.heldObject[1].value + 1 == tableau.cards[#tableau.cards].value and self.heldObject[1].color ~= tableau.cards[#tableau.cards].color then
    print("valid move")
    return true
  else
    print("invalid move")
    return false
  end
end


function GrabberClass:isPilePlacementValid(pile)
  if #self.heldObject ~= 1 then
    return false
  end
  
  if self.heldObject[1].suit ~= pile.suit then
    print("invalid move")
    return false
  end
  
  if #pile.cards == 0 then
    if self.heldObject[1].value == 1 then
      print("valid move")
      return true
    else
      print("invalid move")
      return false
    end
  end
  
  if self.heldObject[1].value == pile.cards[#pile.cards].value + 1 then
    print("valid move")
    return true
  else
    print("invalid move")
    return false
  end
end

--function GrabberClass:isGameWon()
--  for _, pile in ipairs(suitPiles) do
--    if #pile.cards >= 13 then
--      print("Game Won!")
--    end
--  end
--end




