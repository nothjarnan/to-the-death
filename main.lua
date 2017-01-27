require "static_data/interfaces/player"
require "static_data/interfaces/player2"
require "static_data/interfaces/particles"
require "static_data/interfaces/damagetext"
local GJ = require "static_data/gamejolt"
local utf8 = require("utf8")
--> It doesn't work, still. Wtf
version = "v0.1.6 STABLE"
local prefixCMD = "stout"
local totalxp = 0
local xpRequired = 1^2
local isGJCLIENT = false
local isDemo = false
local gjPing = 0
local loggedIn = false
function calculateLevel(xp)

end
function HSL(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

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
	GJ.init(189671,"565ef6206be63effa1026ae6ff8207b6")
  resolution={
    love.graphics.getHeight(),love.graphics.getWidth()
  }
  stats = love.graphics.getStats()

	playerScale = 6
  changeLog = {
    "Changelog To the Death "..version..":",
		"GameJolt login is now supported! write 'gjlogin username&token' in the console to get started!",
		"Trophies are on the way.",
		"Data storage will be used in the future. Woot.",
    "Thank you for testing To the Death!",

  }

  returnString = {
    "TTD "..version.." Debug Console. Enter 'help' for a list of commands",
  }
  --> Commandline settings stuff thingies.
  cheats = false
  excollisions = false
  rainbow = false
  --> The rest of initialization stuff
  server = false
  knownstate = true
  statestested = {}
  printedOnce = false
  inputCMD = ""
  spCMD = false
  gamefont = love.graphics.newFont(12)
	gamejoltfont = love.graphics.newFont(18)
  love.graphics.setDefaultFilter("linear","nearest", 0)
	loginbutton = love.graphics.newImage("static_data/textures/icons/gjloginbutton.png")
	loginfailedicon = love.graphics.newImage("static_data/textures/icons/warning.png")
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
	gjLogo = love.graphics.newImage("static_data/textures/icons/Game-jolt-logo.png")
  gameState = "main_menu"
  menuTime = 0
  a=0
  fadeout = false
  showStats = false
  nightMode = false
  focused = true
	inputlogin = ""
	inputtoken = ""
	loginfailed = false
	tokencensored = string.rep("*",string.len(inputtoken))
	switchinputs = false
  player.load()
  playertwo.load()
	f=false
  if utf8 then cPrint("Has utf8 support") end
  cPrint(resolution[2].."x"..resolution[1])
  if resolution[1] < 1680 and resolution[2] < 1050 then
    love.graphics.setMode(800,600)
  end
  hue = 0
  hue2 = 130
	gjLogin = true
	cursorblink = 0
	cursorShow = true
end
function love.textinput(t)
		if spCMD then
    	inputCMD = inputCMD..t
		end
		if gjLogin then
			--cPrint(inputtoken.." "..inputlogin)

			if switchinputs then
				inputtoken = inputtoken..t
			else
				inputlogin = inputlogin..t
			end
			tokencensored = string.rep("*",string.len(inputtoken))
			--cPrint(inputtoken.." "..inputlogin)
		end
end
function cPrint(string,callerID)
  print(string)
  if not callerID then callerID = "main.lua" end
  if callerID == "WARNING" then spCMD = true end
  returnString[#returnString+1] = "["..callerID.."]: "..tostring(string)
end
function love.focus(focus)
  focused = focus
end
function love.mousepressed(x,y,button,istouch)
	if gjLogin == true and x >= 550 and y >= 423 and x <= 743 and y <= 460 and button == 1 and string.len(inputlogin) > 1 and string.len(inputtoken) > 1 then
		cPrint("Connecting to GameJolt.","GAMEJOLT")
		local success = GJ.authUser(inputlogin,inputtoken)
		if success then
			GJ.openSession()
			loggedIn = true
			gjLogin = false
			cPrint("Successfully logged in!","GAMEJOLT")
		 else
			 loggedIn = false
			 loginfailed = true
			 inputtoken = ""
			 tokencensored = ""
			 cPrint("Invalid credentials.","GAMEJOLT")
		 end
	end
end
function love.keypressed(k)
  --print(k)
	if k == "f11" then
		f = not f
		love.window.setFullscreen(f)
	end
  love.keyboard.setKeyRepeat(spCMD)
	if gjLogin == true and k == "up" then
		switchinputs = true
	end
	if gjLogin == true and k == "escape" then
		gjLogin = false
		inputlogin = ""
		inputtoken = ""
	end
	if gjLogin == true and k == "down" then
		switchinputs = false
	end
	if gjLogin == true then
		love.keyboard.setKeyRepeat(true)
		if k == "backspace" then
		-- get the byte offset to the last UTF-8 character in the string.
		local byteoffset = utf8.offset(inputlogin, -1)
		local byteoffsetpw = utf8.offset(inputtoken, -1)
		if switchinputs == true then
			byteoffset = utf8.offset(inputtoken, -1)
		else
			byteoffset = utf8.offset(inputlogin, -1)
		end

		--cPrint(byteoffset)
		if byteoffset then
				-- remove the last UTF-8 character.
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				if switchinputs == true then
					inputtoken = string.sub(inputtoken , 1, byteoffset -1)
				else
					inputlogin = string.sub(inputlogin , 1, byteoffset - 1)
				end
				tokencensored = string.rep("*",string.len(inputtoken))
		end
	end
	end
  if spCMD == true and isDemo == false then

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
      "  tc - Toggles cheats for this session (Not available in MP)",
      "  connect <ip:port> - Connects to MP server (NYI)",
      "  startserver - Starts a MP server (WIP)",
			"  gjlogin username&token (Do not remove &. It's an important part of the login string. Dunno why *shrug*)"
    }
    local cheatcmd = {
      "Cheats:",
      "  healthp1 <int: health> - Sets player1 health to specified amount",
      "  healthp2 <int: health> - Sets player2 health to specified amount",
      "  god <int:player> - Toggles godmode for specified player (1-2)",
      "  kill <int:player> - Kills specified player (1-2)",
      "  damage <int:player> - Takes off 10hp from specified player (1-2)",
      "  explode <int: player or 'all'> - This is pretty self explanatory"
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
    elseif inputCMD == "rainbows" then
      if rainbow then
        returnString[#returnString+1] = "["..prefixCMD.."]: No rainbows :("
        rainbow = false
      else
        returnString[#returnString+1] = "["..prefixCMD.."]: Wooo rainbows!"
        rainbow = true
      end
		elseif inputCMD == "togglecolliders" then
			excollisions = not excollisions
		elseif string.find(inputCMD,"gjlogin ",1) then
			local tokenUsername = string.gsub(inputCMD,"gjlogin ","")
			local tokenpos = string.find(tokenUsername,"&",1)
			local creds = {
				string.sub(tokenUsername,tokenpos+1),

			}
			creds[2] = string.gsub(tokenUsername,"&"..creds[1],"")
			cPrint(tokenUsername.."|"..tokenpos.." "..creds[1].."+"..creds[2])
			cPrint("Connecting to GameJolt.","GAMEJOLT")
			local success = GJ.authUser(creds[2],creds[1])
			if success then
				GJ.openSession()
				loggedIn = true
				cPrint("Successfully logged in!","GAMEJOLT")
			 else
				 loggedIn = false
				 loginfailed = true
				 cPrint("Invalid credentials.","GAMEJOLT")
			 end
    elseif inputCMD == "tc" then
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
    elseif string.find(inputCMD,"explode ",1) and cheats == true then
      local pl = string.gsub(inputCMD,"explode ","")
      if pl == "1" then
        player.sendDamage(99999)
        cPrint("Player1 killed.",prefixCMD)
      elseif pl == "2" then
        playertwo.sendDamage(99999)
        cPrint("Player2 killed.",prefixCMD)
      elseif pl == "all" then
        player.sendDamage(99999)
        playertwo.sendDamage(99999)
        cPrint("Player1 & Player2 killed.",prefixCMD)
      else
        cPrint(pl.." is not a valid player ID!",prefixCMD)
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
        player.health = -99.9*10^5
        returnString[#returnString+1] = "["..prefixCMD.."]: Player1 is now dead."
      end
      if ply == "2" then
        playertwo.health = -99.9*10^5
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
  if k == "f6" and gameState == "game" then
    player.reset()
    playertwo.reset()
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
    deleteParticles()
    player.reset()
    playertwo.reset()
    if nightMode == true and gameState == "player_1_wins" or gameState == "player_2_wins" then
      nightMode = false
    end
    gameState = "main_menu"
  end
	if k == "f1" and gameState == "main_menu" then
	 gjLogin = not gjLogin
	 cPrint(gjLogin,"GAMEJOLT")
	end
  if k == "f5" and isDemo == false then
    inputCMD =""
    spCMD = not spCMD
    nightMode = spCMD
  end
  print(k,menuTime,spCMD)
	if k == "return" and gjLogin == true then
		switchinputs = not switchinputs
	end
  if k == "return" and menuTime > 7.5 and spCMD == false and gjLogin == false then
    if gameState == "main_menu" then
      level = love.math.random(1,2)
      cPrint("LEVEL:"..level)
      gameState = "game"
      nightMode = false
      player.load()
      playertwo.load()
      deleteParticles()
    end
  end
end
function love.update(dt)
	if love.event then
		for e,a,b,c in love.event.poll() do
			cPrint("e","event")
		end
	end
  local nOK = 0
  local nERR = 0
  pl1Cooldown = 10
  pl2Cooldown = 10
	if gjPing > 30 and loggedIn == true then
		gjPing = 0
		local success = GJ.pingSession(true)
		if success then cPrint("Successfully pinged session.","GAMEJOLT") else cPrint("Could not ping session!") end
	end
	gjPing = gjPing + 1 * dt
  if hue >= 255 then
    hue = 0
  else
    hue = hue + 150*dt
  end
	if cursorblink == 0.5 then
		cursorblink = 0
		cursorShow = not cursorShow
	end
	cursorblink = cursorblink + 1 * dt
  if hue2 >= 255 then
    hue2 = 0
  else
    hue2 = hue2 + 150*dt
  end
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
    updateParticles(dt)
    updateTexts(dt)
    player.setOpponentPosition(playertwo.x, playertwo.y, 0, 0)
    playertwo.setOpponentPosition(player.x,player.y,0,0)
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

      love.graphics.draw(menuBG,love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,1,1,menuBG:getWidth()/2,menuBG:getHeight()/2)
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
			if gjLogin == true then
				love.graphics.setColor(40,40,40,140)
				love.graphics.rectangle("fill",1,1,love.graphics.getWidth(),love.graphics.getHeight())
				love.graphics.setColor(40,40,40,190)
				love.graphics.rectangle("fill",1,(love.graphics.getWidth()*.25)-(gjLogo:getHeight()*1.1),love.graphics.getWidth(),370)
				love.graphics.setColor(255,255,255,255)
				love.graphics.draw(gjLogo,love.graphics.getWidth()/2,love.graphics.getHeight()*(1.5/4),0,0.3,0.3,gjLogo:getWidth()/2,gjLogo:getHeight()/2)
				if switchinputs == false then
					love.graphics.setColor(204,255,0,255)
					love.graphics.rectangle("fill", (love.graphics.getWidth()*.3)-5, love.graphics.getHeight()*(1.5/3)-45, (love.graphics.getWidth()/2.5)+10, 40)
				else
					love.graphics.setColor(204,255,0,255)
					love.graphics.rectangle("fill", (love.graphics.getWidth()*.3)-5, love.graphics.getHeight()*(1.5/3)-5, (love.graphics.getWidth()/2.5)+10, 40)
				end
				love.graphics.setColor(255,255,255,255)
				if loginfailed then
					love.graphics.draw(loginfailedicon,love.graphics.getWidth()*.3,love.graphics.getHeight()*(1.5/3)-73,0,0.9,0.9)
					love.graphics.setColor(255,20,20,255)
					love.graphics.print("Login failed! Check your credentials and try again.",love.graphics.getWidth()*.3 + 35,love.graphics.getHeight()*(1.5/3)-64)
					love.graphics.setColor(255,255,255,255)
				end
				love.graphics.rectangle("fill", love.graphics.getWidth()*.3, love.graphics.getHeight()*(1.5/3)-40, love.graphics.getWidth()/2.5, 30)
				love.graphics.rectangle("fill", love.graphics.getWidth()*.3, love.graphics.getHeight()*(1.5/3), love.graphics.getWidth()/2.5, 30)
				love.graphics.setFont(gamejoltfont)
				love.graphics.setColor(0,0,0,255)
				love.graphics.print(inputlogin,(love.graphics.getWidth()*.3)+5, (love.graphics.getHeight()*(1.5/3)-40)+5)
				love.graphics.print(tokencensored,(love.graphics.getWidth()*.3)+5,(love.graphics.getHeight()*(1.5/3)+5))
				love.graphics.setFont(gamefont)
				if string.len(inputlogin) > 1 and string.len(inputtoken) > 1 then
					love.graphics.setColor(255,255,255,255)
					love.graphics.draw(loginbutton,550,423)
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
      --love.graphics.rectangle("line",player.x-25,player.y,50,player.currentTexture:getHeight()*5)
      --love.graphics.rectangle("line",playertwo.x-25,playertwo.y,50,playertwo.currentTexture:getHeight()*5)
      if nightMode == true then
        love.graphics.setColor(140,140,140,255)
      else
        love.graphics.setColor(255,255,255,255)
      end
    end
    if gameState == "player_2_wins" then
      --print("PLAYER 2 WINS")
      love.graphics.setColor(HSL(hue,255,200))
      love.graphics.draw(winScreens[2],love.graphics.getWidth()/2-winScreens[2]:getWidth()/2,love.graphics.getHeight()*0.33)
      love.graphics.setColor(255, 255, 255, 255)
    end
    if gameState == "player_1_wins" then
      --print("PLAYER 1 WINS")
      love.graphics.setColor(HSL(hue,255,200))
      love.graphics.draw(winScreens[1],love.graphics.getWidth()/2-winScreens[1]:getWidth()/2,love.graphics.getHeight()*0.33)
      love.graphics.setColor(255, 255, 255, 255)
    end
    player.draw()
    renderParticles()
    renderText()
    playertwo.draw()
  end
  if showStats == true then
    love.graphics.setColor(97,224,105,255)
    love.graphics.print("GRAPHICS STATS: \n DRAW_CALLS: "..stats.drawcalls.." \n CANVAS_SWITCHES: "..stats.canvasswitches.."\n GRAPHICS_MEMORY: "..(stats.texturememory/1024/1024).."MB \n FPS: "..love.timer.getFPS().."\n PLAYER1XY: "..player.x..";"..player.y.."\n PLAYER2XY: "..playertwo.x..";"..playertwo.y.."\n PLAYER1COLL: "..tostring(player.collided).."\n PLAYER2COLL: "..tostring(playertwo.collided).."\n T: "..timer.."\n T2: "..timertwo.."\n hue:"..hue.."\n len particles:"..#particles.."\n playerScale:"..playerScale.."\n p1sf: "..scaleFactor.."\n p2sf"..scaleFactortwo,1,1)
  end
  if spCMD == true then
    love.graphics.setColor(20,20,20,90)
    love.graphics.rectangle("fill",1,love.graphics.getHeight()-28-(16*#returnString),love.graphics.getWidth(),love.graphics.getHeight()-28)


    love.graphics.setColor(97,224,105,255)

    for k,v in ipairs(returnString) do
      love.graphics.print(returnString[k],1,love.graphics.getHeight()-42+(16*k)-(16*#returnString))
    end
    love.graphics.setColor(50,50,50,255)
    love.graphics.line(1,love.graphics.getHeight()-29,love.graphics.getWidth(),love.graphics.getHeight()-29)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print("> "..inputCMD,1,love.graphics.getHeight()-21)
    love.graphics.setColor(255,255,255,255)
  end
  love.graphics.setColor(255,255,255,255)
	if isDemo then
  	love.graphics.print("To the Death Demo",5,5)
	end
	stats = love.graphics.getStats()
end
