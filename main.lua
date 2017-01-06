require "static_data/interfaces/player" --> Apparently interfaces cannot be outside of root directories. What the hell?
--> It doesn't work, still. Wtf

function love.load()
  local levelbackgrounds = {}
  local spriteBatch = {}
  menuIcon = love.graphics.newImage("static_data/textures/icons/ttd_banner.png")
  nothyLogo = love.graphics.newImage("static_data/textures/icons/nothy-logo-white.png")
  gameState = "main_menu"
  menuTime = 0
  a=0
  fadeout = false
  player.load()
end

function love.update(dt)

  if gameState == "main_menu" then
    menuTime = menuTime + 1 *dt
    if a > 0 then
      print(a)
    end
    if a >= 255 and fadeout == false then
      a = 255
      if menuTime > 4 then
        fadeout = true
      end
    else
      if menuTime > 2 then
        if fadeout == false then
          a = a + 170 * dt
        else
          if a < 0 then
            a = 0
          else
            a = a - 170 * dt
          end
        end
      end
    end
    if love.keyboard.isDown("return") and menuTime > 10 then
      gameState = "game"
    end
  else
    playerUpdate(dt)
  end
end

function love.draw()
  if gameState == "main_menu" then
    if menuTime > 8 then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(menuIcon,love.graphics.getWidth()/2, love.graphics.getHeight()/3,0,1,1,menuIcon:getWidth()/2, menuIcon:getHeight()/2)
    else
      love.graphics.setColor(255,255,255,a)
      love.graphics.draw(nothyLogo,love.graphics.getWidth()/2, love.graphics.getHeight()/2,0,1,1,nothyLogo:getWidth()/2, nothyLogo:getHeight()/2)
    end
  else
    player.draw()
  end

end
