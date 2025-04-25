
StackClass = {}

function StackClass:new(x, y)
  local stack = {}
  local metadata = {__index = StackClass}
  setmetatable(stack, metadata)
  
  stack.x = x
  stack.y = y
  stack.leftBound = stack.x - 19
  stack.rightBound = stack.x + 105
  stack.topBound = stack.y - 50
  stack.bottomBound = stack.y + 250
  stack.cards = {}
  
  return stack
end

function StackClass:addCard(card, offset)
  table.insert(self.cards, card)
  card.position = Vector(self.x, self.y + (#self.cards - 1) * (offset or 30))
  self.bottomBound = self.bottomBound + (offset or 30)
end

function StackClass:removeCard(index, offset)
  if index then
    table.remove(self.cards, index)
  end
  if index == #self.cards then
    self.bottomBound = self.bottomBound - (offset or 30)
  end

end

function StackClass:draw()
  love.graphics.setColor(0.8, 0.8, 0.8, 1)
  love.graphics.rectangle("fill", self.x, self.y, 90, 120)
end

function StackClass:contains(card)
  for i, c in ipairs(self.cards) do
    if c == card then
      return i
    end
  end
  return nil
end

function StackClass:flipTopCardUp()
  if #self.cards > 0 and self.cards[#self.cards].faceUp == false then
    self.cards[#self.cards]:flip()
  end
end