require "static_data/interfaces/player" --> Apparently interfaces cannot be outside of root directories. What the hell?
require "static_data/interfaces/player2"
--> It doesn't work, still. Wtf
version = "v0.0.1 ALPHA"
function love.load()

  love.graphics.setDefaultFilter("linear","nearest", 0)
  levelbackgrounds = {
      love.graphics.newImage("static_data/textures/environment/city.png"),
      love.graphics.newImage("static_data/textures/environment/temple.png")
  }
  level = math.random(1,#levelbackgrounds)
  menuIcon = love.graphics.newImage("static_data/textures/icons/ttd_banner.png")
  nothyLogo = love.graphics.newImage("static_data/textures/icons/nothy-logo-white.png")
  pressEnter = love.graphics.newImage("static_data/textures/icons/pressenter.png")
  menuBG = love.graphics.newImage("static_data/textures/icons/menubg.png")
  gameState = "main_menu"
  menuTime = 0
  a=0
  fadeout = false
  showStats = false
  player.load()
  playertwo.load()
end
function love.keypressed(k)
  if k == "f3" then
    showStats = not showStats
  end
end
function love.update(dt)

  if love.keyboard.isDown("escape") then
    player.reset()
    playertwo.reset()
    gameState = "main_menu"
  end
  if gameState == "main_menu" then
    menuTime = menuTime + 1 *dt
    if a > 0 then
      --print(a)
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
          if a < 0 and menuTime < 8 then
            a = 0
          else
            a = a - 170 * dt
            if a < 0 and menuTime > 8 and gameState == "main_menu" then
              fadeout = false
            end
          end
        end
      end
    end
    if love.keyboard.isDown("return") and menuTime > 7.5 then
      gameState = "game"
    end
  else
    player.update(dt)
    playertwo.update(dt)
    player.setOpponentPosition(playertwo.x, playertwo.y, playertwo.width, playertwo.height)
  end
end

function love.draw()


  if gameState == "main_menu" then
    if menuTime > 8 then
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(menuBG,love.graphics.getWidth()/2, love.graphics.getHeight()/2,math.rad(-10),0.9,0.9,menuBG:getWidth()/2, menuBG:getHeight()/2)
      love.graphics.print("To the Death | "..version,1,love.graphics.getHeight()-12)
      love.graphics.setColor(0,0,0,255)
      love.graphics.draw(menuIcon,love.graphics.getWidth()/2, love.graphics.getHeight()/3,0,1,1,menuIcon:getWidth()/2, menuIcon:getHeight()/2)
      love.graphics.setColor(0,0,0,a)
      love.graphics.draw(pressEnter,love.graphics.getWidth()/2, love.graphics.getHeight()/1.5,0,0.5,0.5,pressEnter:getWidth()/2, pressEnter:getHeight()/2)
    else
      love.graphics.setColor(255,255,255,a)
      love.graphics.draw(nothyLogo,(love.graphics.getWidth()/2)+10, love.graphics.getHeight()/2,0,0.6,0.6,nothyLogo:getWidth()/2, nothyLogo:getHeight()/2)
    end
  else
    love.graphics.setBackgroundColor(0,0,0)
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(levelbackgrounds[level],love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,4.8,4.8,levelbackgrounds[level]:getWidth()/2,levelbackgrounds[level]:getHeight()/2)
    love.graphics.print("To the Death | "..version,1,love.graphics.getHeight()-12)
    player.draw()
    playertwo.draw()
  end
  if showStats == true then
    local stats = love.graphics.getStats()
    love.graphics.setColor(0,180,0,255)
    love.graphics.print("GRAPHICS STATS: \n DRAW_CALLS: "..stats.drawcalls.." \n CANVAS_SWITCHES: "..stats.canvasswitches.."\n GRAPHICS_MEMORY: "..(stats.texturememory/1024).."KB \n FPS: "..love.timer.getFPS().."\n PLAYER1XY: "..player.x..";"..player.y.."\n PLAYER2XY: "..playertwo.x..";"..playertwo.y,1,1)
  end
end
