require "static_data/interfaces/player" --> Apparently interfaces cannot be outside of root directories. What the hell?
require "static_data/interfaces/player2"

local utf8 = require("utf8")
--> It doesn't work, still. Wtf
version = "v0.1.4 ALPHA"
local prefixCMD = "stout"
local isGJCLIENT = false


function onConnect(ip,port)
  cPrint("Client "..ip..":"..port.." connected.")
end
function onDisconnect(ip, port)
  cPrint("Client "..ip..":"..port.." disconnected.")
end

function onReceive(data,ip,port)

end
function clientReceive(data)

end
function love.load()
  stats = love.graphics.getStats()
  changeLog = {
    "Changelog To the Death "..version..":",
    "- Players no longer collide, since it only causes problems anyway.",
    "  Collisions are calculated though, and are used for hit registration.",
    "- Debug console! Press F5 to use it. There are *some* commands for it.",
    "- Night mode: Press F4 to enable night mode. It helps a lot.",
    "- Level re-added: City. Should work a tiny bit better this time",
    "- You can now attack opponents. Player 1 can attack with left shift",
    "  and Player 2 can attack with right shift.",
    "Thank you for testing To the Death!",

  }
  returnString = {
    "TTD "..version.." Debug Console. Enter 'help' for a list of commands",
  }
  --> Commandline settings stuff thingies.
  cheats = false
  excollisions = false
  --> The rest of initialization stuff
  server = false
  knownstate = true
  statestested = {}
  printedOnce = false
  inputCMD = ""
  spCMD = false
  love.graphics.setDefaultFilter("linear","nearest", 0)
  knownstates = {
    "main_menu",
    "game",
    "player_1_wins",
    "player_2_wins",
  }
  levelbackgrounds = {
      love.graphics.newImage("static_data/textures/environment/city.png"),
      love.graphics.newImage("static_data/textures/environment/temple.png"),
      love.graphics.newImage("static_data/textures/environment/city.png"),
      love.graphics.newImage("static_data/textures/environment/temple.png"),
  }
  winScreens = {
    love.graphics.newImage("static_data/textures/deco/player_1_wins.png"),
    love.graphics.newImage("static_data/textures/deco/player_2_wins.png")
  }
  level = love.math.random(#levelbackgrounds)
  cPrint("LEVEL: "..level)
  menuIcon = love.graphics.newImage("static_data/textures/icons/ttd_banner.png")
  nothyLogo = love.graphics.newImage("static_data/textures/icons/nothy-logo-white.png")
  pressEnter = love.graphics.newImage("static_data/textures/icons/pressenter.png")
  menuBG = love.graphics.newImage("static_data/textures/icons/menubg.png")
  gameState = "main_menu"
  menuTime = 0
  a=0
  fadeout = false
  showStats = false
  nightMode = false
  focused = true
  player.load()
  playertwo.load()
  if utf8 then cPrint("Has utf8 support") end
end
function love.textinput(t)
    inputCMD = inputCMD..t
end
function cPrint(string,callerID)
  print(string)
  if not callerID then callerID = "main.lua" end
  returnString[#returnString+1] = "["..callerID.."]: "..string
end
function love.focus(focus)
  focused = focus
end
function love.keypressed(k)
  --print(k)
  love.keyboard.setKeyRepeat(spCMD)
  if spCMD == true then

    if k == "backspace" then
    -- get the byte offset to the last UTF-8 character in the string.
    local byteoffset = utf8.offset(inputCMD, -1)

    if byteoffset then
        -- remove the last UTF-8 character.
        -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
        inputCMD = string.sub(inputCMD, 1, byteoffset - 1)
    end
  end
  if k == "return" and spCMD == true then
    --cPrint(inputCMD)
    local allcmd = {
      "Command list: ",
      "  clear - Clears console",
      "  crash - Useless. Crashes the game",
      "  exit - Closes console",
      "  getlevel - Prints level ID",
      "  getstate - Prints gamestate",
      "  level <int: level> - Sets current level to specified int",
      "  setstate <string: state> - Sets gamestate [DANGEROUS]",
      "  togglecolliders - Toggles experimental collisions on and off [BUGGY]",
      "  togglecheats - Toggles cheats for this session (Not available in MP)",
      "  connect <ip:port> - Connects to MP server (NYI)",
      "  startserver - Starts a MP server (WIP)",
    }
    local cheatcmd = {
      "Cheats:",
      "  healthp1 <int: health> - Sets player1 health to specified amount",
      "  healthp2 <int: health> - Sets player2 health to specified amount",
      "  god <int:player> - Toggles godmode for specified player (1-2)",
      "  kill <int:player> - Kills specified player (1-2)",
      "  damage <int:player> - Takes off 10hp from specified player (1-2)",
    }
    returnString[#returnString+1] = inputCMD
    if inputCMD == "help" then
      for k,v in ipairs(allcmd) do
        returnString[#returnString+1] = v
      end
      if cheats == true then
        for k,v in ipairs(cheatcmd) do
            returnString[#returnString+1] = v
        end
      end
    elseif inputCMD == "exit" then
      returnString[#returnString+1] = "["..prefixCMD.."]: Exiting."
      spCMD = false
    elseif string.find(inputCMD,"level ",1) then
      local c = inputCMD
      local newLevel = string.gsub(c,"level ","")
      if tonumber(newLevel) > #levelbackgrounds then
        returnString[#returnString+1] = "["..prefixCMD.."]: Number too large! Number can only be between 1-"..#levelbackgrounds.."."
      else
        level = tonumber(newLevel)
        returnString[#returnString+1] = "["..prefixCMD.."]: Level set to "..level
      end
    elseif inputCMD == "getlevel" then
      returnString[#returnString+1] = "["..prefixCMD.."]: "..level
    elseif inputCMD == "getstate" then
      returnString[#returnString+1] = "["..prefixCMD.."]: "..gameState
    elseif string.find(inputCMD,"setstate ",1) then
      local c = inputCMD
      local newState = string.gsub(c,"setstate ","")
      gameState = newState
      returnString[#returnString+1] = "["..prefixCMD.."]: Gamestate now set to "..gameState
    elseif inputCMD == "crash" then
      error("I don't know why you'd wanna do this but.. OK")
    elseif inputCMD == "clear" then
      returnString = {
        "TTD "..version.." Debug Console. Enter 'help' for a list of commands",
      }
    elseif inputCMD == "togglecheats" then
      cheats = not cheats
      if cheats == true then
        returnString[#returnString+1] = "["..prefixCMD.."]: Cheats enabled."
      else
        returnString[#returnString+1] = "["..prefixCMD.."]: Cheats disabled."
      end
    elseif string.find(inputCMD,"god ",1) and cheats == true then
      local ply = inputCMD
      local pl = string.gsub(ply,"god ","")
      --cPrint(player)
      if pl == "1" then
        player.god = not player.god
        if player.god == true then
          returnString[#returnString+1] = "["..prefixCMD.."]: Player1 is now god."
        else
          returnString[#returnString+1] = "["..prefixCMD.."]: Player1 is no longer god."
        end
      end
      if pl== "2" then
        playertwo.god = not playertwo.god
        if playertwo.god == true then
          returnString[#returnString+1] = "["..prefixCMD.."]: Player2 is now god."
        else
          returnString[#returnString+1] = "["..prefixCMD.."]: Player2 is no longer god."
        end
      end
    elseif string.find(inputCMD,"damage ",1) and cheats == true then
      local ply = string.gsub(inputCMD,"damage ","")
      if ply == "1" then
        player.health = player.health -10
        returnString[#returnString+1] = "["..prefixCMD.."]: Player1 health is now "..player.health.."/100"
      end
      if ply == "2" then
        playertwo.health = playertwo.health -10
        returnString[#returnString+1] = "["..prefixCMD.."]: Player2 health is now "..playertwo.health.."/100"
      end
    elseif string.find(inputCMD,"kill ",1) and cheats == true then
      local ply = string.gsub(inputCMD,"kill ","")
      if ply == "1" then
        player.health = 0
        returnString[#returnString+1] = "["..prefixCMD.."]: Player1 is now dead."
      end
      if ply == "2" then
        playertwo.health = 0
        returnString[#returnString+1] = "["..prefixCMD.."]: Player2 is now dead"
      end
    elseif string.find(inputCMD,"healthp",1) and cheats == true then
      local plyhp = string.gsub(inputCMD,"healthp","")
      if string.find(plyhp,"1 ",1) then
        local newhp = string.gsub(plyhp,"1 ","")
        player.health = tonumber(newhp)
        returnString[#returnString+1] = "["..prefixCMD.."]: Player1 health set to "..player.health
      end
      if string.find(plyhp,"2 ",1) then
        local newhp = string.gsub(plyhp,"2 ","")
        playertwo.health = tonumber(newhp)
        returnString[#returnString+1] = "["..prefixCMD.."]: Player2 health set to "..playertwo.health
      end
    elseif inputCMD == "resetplayers" then
      player.reset()
      playertwo.reset()
      gameState = "game"
    elseif inputCMD == "startserver" then
      serv = lube.server(18025)
      serv:setCallBack(onReceive, onConnect, onDisconnect)
      serv:setHandshake("Hello")
      server = true
    elseif string.find(inputCMD,"connect ",1) then
      local connectIP = string.gsub(inputCMD,"connect ","")
      local st,en = string.find(connectIP,":",1)
      local portStr = string.sub(connectIP,st)
      connectIP = string.gsub(connectIP,portStr,"")
      portStr = string.gsub(portStr,":","")
      cPrint(connectIP,portStr)
    else
      returnString[#returnString+1] = "["..prefixCMD.."]: "..inputCMD..": unknown command. Enter 'help' for a list of commands."
    end
    inputCMD = ""
  end
  end
  if k == "f3" and love.filesystem.isFused() == false then
    showStats = not showStats
  end
  if k == "f4" then
    if spCMD == false then
      nightMode = not nightMode
    end
  end
  if k == "escape" then
    player.reset()
    playertwo.reset()
    gameState = "main_menu"
  end
  if k == "f5" then
    inputCMD =""
    spCMD = not spCMD
    nightMode = spCMD
  end
  print(k,menuTime,spCMD)
  if k == "return" and menuTime > 7.5 and spCMD == false then
    if gameState == "main_menu" then
      level = love.math.random(1,2)
      cPrint("LEVEL:"..level)
      gameState = "game"
    end
  end
end
function love.update(dt)
  local nOK = 0
  local nERR = 0
  pl1Cooldown = 10
  pl2Cooldown = 10
  if pl1Cooldown <= 0 then
    pl1Cooldown = 0
  else
    pl1Cooldown = pl1Cooldown -1*dt
  end
  if server == true then
    serv:update(dt)
  end
  for k,v in ipairs(knownstates) do
    if gameState == v then
      nOK = nOK+1
    else
      nERR = nERR +1
    end
  end
  if nOK >= 1 then
    printedOnce = false
    knownstate = true
  else
    if printedOnce == false then
      cPrint("Unknown state!","WARNING")
      printedOnce = true
    end
    knownstate = false
    spCMD = true
  end
  if knownstate == true then
    printedOnce = false
  end
  if #returnString > 35 then
    table.remove(returnString,1)
  end

  if gameState == "main_menu" then
    menuTime = menuTime + 1 *dt
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

  else
    player.update(dt)
    playertwo.update(dt)
    player.setOpponentPosition(playertwo.x, playertwo.y, playertwo.currentTexture:getWidth(), playertwo.currentTexture:getHeight()*5)
    playertwo.setOpponentPosition(player.x,player.y,player.currentTexture:getWidth(),player.currentTexture:getHeight()*5)
  end
end

function love.draw()


  if gameState == "main_menu" then
    if menuTime > 8 then
      if nightMode == true then
        love.graphics.setColor(140,140,140,255)
      else
        love.graphics.setColor(255,255,255,255)
      end

      love.graphics.draw(menuBG,love.graphics.getWidth()/2, love.graphics.getHeight()/2,math.rad(-10),0.9,0.9,menuBG:getWidth()/2, menuBG:getHeight()/2)
      love.graphics.setColor(0,0,0,255)
      love.graphics.draw(menuIcon,love.graphics.getWidth()/2, love.graphics.getHeight()/3,0,1,1,menuIcon:getWidth()/2, menuIcon:getHeight()/2)
      love.graphics.setColor(0,0,0,a)
      love.graphics.draw(pressEnter,love.graphics.getWidth()/2, love.graphics.getHeight()/1.5,0,0.5,0.5,pressEnter:getWidth()/2, pressEnter:getHeight()/2)
      if #changeLog > 1 then
        for k,v in ipairs(changeLog) do
          love.graphics.setColor(0,0,0,255)
          love.graphics.print(v,30,30+(16*k))
        end
      end
    else
      love.graphics.setColor(255,255,255,a)
      love.graphics.draw(nothyLogo,(love.graphics.getWidth()/2)+10, love.graphics.getHeight()/2,0,0.6,0.6,nothyLogo:getWidth()/2, nothyLogo:getHeight()/2)
    end
  else

    love.graphics.setBackgroundColor(0,0,0)
    if nightMode == true then
      love.graphics.setColor(140,140,140,255)
    else
      love.graphics.setColor(255,255,255,255)
    end

    love.graphics.draw(levelbackgrounds[level],love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,4.8,4.8,levelbackgrounds[level]:getWidth()/2,levelbackgrounds[level]:getHeight()/2)

    if showStats == true then
      love.graphics.setColor(255,0,0,255)
      love.graphics.rectangle("line",player.x-25,player.y,50,player.currentTexture:getHeight()*5)
      love.graphics.print("PLAYER1: COLLIDERSTARTXY:("..(player.x-25).."x"..(player.x+50).."y)",1,150)
      love.graphics.line(1,168,player.x,player.y)
      love.graphics.rectangle("line",playertwo.x-25,playertwo.y,50,playertwo.currentTexture:getHeight()*5)
      love.graphics.print("PLAYER2: COLLIDERSTARTXY:("..(playertwo.x-25).."x"..(playertwo.x+50).."y)",1,180)
      love.graphics.line(1,180,playertwo.x,playertwo.y)
      if nightMode == true then
        love.graphics.setColor(140,140,140,255)
      else
        love.graphics.setColor(255,255,255,255)
      end
    end
    if gameState == "player_2_wins" then
      --print("PLAYER 2 WINS")
      love.graphics.draw(winScreens[2],1,1)
    end
    if gameState == "player_1_wins" then
      --print("PLAYER 1 WINS")
      love.graphics.draw(winScreens[1],1,1)
    end
    player.draw()
    playertwo.draw()
  end
  if showStats == true then
    love.graphics.setColor(255,0,0,255)
    love.graphics.print("GRAPHICS STATS: \n DRAW_CALLS: "..stats.drawcalls.." \n CANVAS_SWITCHES: "..stats.canvasswitches.."\n GRAPHICS_MEMORY: "..(stats.texturememory/1024).."KB \n FPS: "..love.timer.getFPS().."\n PLAYER1XY: "..player.x..";"..player.y.."\n PLAYER2XY: "..playertwo.x..";"..playertwo.y.."\n PLAYER1COLL: "..tostring(player.collided).."\n PLAYER2COLL: "..tostring(playertwo.collided).."\n T: "..timer.."\n T2: "..timertwo,1,1)
  end
  if spCMD == true then
    love.graphics.setColor(0,0,0,128)
    love.graphics.rectangle("fill",1,love.graphics.getHeight()-28-(16*#returnString),love.graphics.getWidth(),love.graphics.getHeight()-28)


    love.graphics.setColor(97,224,105,255)

    for k,v in ipairs(returnString) do
      love.graphics.print(returnString[k],1,love.graphics.getHeight()-42+(16*k)-(16*#returnString))
    end
    love.graphics.setColor(0,0,0,200)
    love.graphics.line(1,love.graphics.getHeight()-29,love.graphics.getWidth(),love.graphics.getHeight()-29)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print("> "..inputCMD,1,love.graphics.getHeight()-21)
    love.graphics.setColor(255,255,255,255)
  end
  love.graphics.setColor(255,255,255,255)
  --love.graphics.print("To the Death | "..version,1,love.graphics.getHeight()-14)
  stats = love.graphics.getStats()
end
