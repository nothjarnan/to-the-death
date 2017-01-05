require "static_data/interfaces/player" --> Apparently interfaces cannot be outside of root directories. What the hell?
--> It doesn't work, still. Wtf

function love.load()
  local levelbackgrounds = {}
  local spriteBatch = {}
  player.load()
end

function love.update(dt)
  playerUpdate(dt)
end

function love.draw()
  player.draw()
end
