
--require "stack"

--DeckClass = {}

--function DeckClass:new(x, y)
--  local deck = {}
--  local metadata = {__index = DeckClass}
--  setmetatable(deck, metadata)
  
--  deck.x = x
--  deck.y = y
--  deck.deckPile = {}
  
--  return deck
--end

--function DeckClass:addCard(card)
--  table.insert(self.deckPile, card)
--  card.position = Vector(self.x, self.y)
--end

--function DeckClass:draw()
  
--  --if cards in draw pile, remove them from the draw pile and place into the discard pile
--  if #drawPile.cards > 0 then
--    for i = 1, #drawPile.cards do
--      discardPile:addCard(drawPile.cards[1])
--      table.remove(drawPile.cards, 1)
--    end
--  end
  
--  --if self.deckPile is empty, then iterate through discard pile, removing the last inserted card and adding it to self.deckPile
--  if #self.deckPile == 0 then
--    for i = 1, #discardPile.cards do
--      self:addCard(discardPile.cards[#discardPile.cards])
--      self.deckPile[#self.deckPile]:flip()
--      table.remove(discardPile.cards)
--    end
--  end
  
--  --add three cards to the drawPile if self.deckPile has 3 or more cards. If not, then just add as many cards as possible to the drawPile
--  for i = 1, 3 do
--    if #self.deckPile > 0 then
--      drawPile:addCard(self.deckPile[#self.deckPile])
--      placeOnTop(drawPile.cards[#drawPile.cards])
--      drawPile:flipTopCardUp()
--      table.remove(self.deckPile)
--    end
--  end
--end


--require "stack"

--DeckClass = {}

--function DeckClass:new(x, y)
--  local deck = {}
--  local metadata = {__index = DeckClass}
--  setmetatable(deck, metadata)
  
--  deck.x = x
--  deck.y = y
--  deck.deckPile = {}
--  deck.drawPile = StackClass:new(100, 250) 
--  deck.discardPile = StackClass:new(-200, 250) --this is off screen to temporarily put the cards that used to be in the draw pile
  
--  return deck
--end

--function DeckClass:addCard(card)
--  table.insert(self.deckPile, card)
--  card.position = Vector(self.x, self.y)
--end

--function DeckClass:draw()
  
--  --if cards in draw pile, remove them from the draw pile and place into the discard pile
--  if #self.drawPile.cards > 0 then
--    for i = 1, #self.drawPile.cards do
--      self.discardPile:addCard(self.drawPile.cards[1])
--      table.remove(self.drawPile.cards, 1)
--    end
--  end
  
--  --if self.deckPile is empty, then iterate through discard pile, removing the last inserted card and adding it to self.deckPile
--  if #self.deckPile == 0 then
--    for i = 1, #self.discardPile.cards do
--      self:addCard(self.discardPile.cards[#self.discardPile.cards])
--      self.deckPile[#self.deckPile]:flip()
--      table.remove(self.discardPile.cards)
--    end
--  end
  
--  --add three cards to the drawPile if self.deckPile has 3 or more cards. If not, then just add as many cards as possible to the drawPile
--  for i = 1, 3 do
--    if #self.deckPile > 0 then
--      self.drawPile:addCard(self.deckPile[#self.deckPile])
--      placeOnTop(self.drawPile.cards[#self.drawPile.cards])
--      self.drawPile:flipTopCardUp()
--      table.remove(self.deckPile)
--    end
--  end
--end
