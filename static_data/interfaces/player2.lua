playertwo = {}
opponentt={
  width = 0,
  height = 0,
  x = 0,
  y = 0
}
groundLeveltwo = love.graphics.getHeight()-325
gravitytwo = (35*100)
scaleFactortwo = 6
timertwo = 2
function playertwo.load(playerNumber)
  playertwo.exploded = false
  playercol = {
    love.math.random(90,255), love.math.random(110,255) , love.math.random(90,255)
  }
  cPrint("Loaded attack sprites for weapon: fists","player2.lua")
  cPrint("Finished loading.","player2.lua")
  --spritebatch = love.graphics.newSpriteBatch(love.graphics.newImage("static_data/textures/playerSprites/spriteAtlas.png"),20,"dynamic")
  playerNumber = nil --> Completely unimportant number, dunno why it's there when I'm doing object oriented programming. What the hell.
  playertwo.x = love.graphics.getWidth()-150 -->
  playertwo.y = 330 --> Literal X and Y coordinates for player.
  playertwo.friction = 13 --> Air resistance/friction, used for calculating slowing down.
  playertwo.speed = 2000 --> .. Top speed.
  playertwo.xvel = 0 --> Player object's velocity in each direction
  playertwo.yvel = 0 -->

  playertwo.width = 35 -->
  playertwo.height = 7 --> Not sure if these will be useless in a bit.
  playertwo.textureIdle = {} --> TODO: Load textures for every weapon. (animation)
  playertwo.totalJumps = 0
  playertwo.textureIdle = love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png")
  playertwo.currentTexture = player.textureIdle
  playertwo.runTexture = {}
  playertwo.attackTexture = {}
  playertwo.canAttack = true
  playertwo.collided = false
  playertwo.inGround = true
  --> Weapon stuff.
  if isDemo then
    playertwo.weapons = {
      "fists","sword"
    }
  else
    playertwo.weapons = {
      "fists","sword"
    }
  end
  playertwo.health = 100
  playertwo.weapon = player.weapon
  playertwo.god = false
end

function playertwo.hitReg(dt)
  --TODO: Figure out an efficient way to code the player hitreg
end

function playertwo.movement(dt)
  --TODO: Movement being very smooth. Like. Very, very smooth.
  if love.keyboard.isDown("right") and playertwo.xvel <  playertwo.speed and gameState ~= "player_2_wins" then
    playertwo.xvel = playertwo.xvel + playertwo.speed * dt
  end
  if love.keyboard.isDown("left") and player.xvel >  -player.speed and gameState ~= "player_2_wins" then
    playertwo.xvel = playertwo.xvel - playertwo.speed * dt
  end
  if love.keyboard.isDown("up") and playertwo.xvel <  playertwo.speed and gameState ~= "player_2_wins" then
    if (playertwo.y + playertwo.height) >= groundLeveltwo-10 then
      playertwo.yvel = -900
    elseif playertwo.totalJumps == 0 then
      playertwo.totalJumps = 1
    end
  end

end
function playertwo.animate(dt) --> I'm not even sure how the hell this even works properly, but it works. So I'll keep it.
  timertwo = timertwo + 3 * dt    --> Whackjob, right? Riiiight? ..no?
  timertwo_floored = math.floor(timertwo)
  --cPrint(tostring(playertwo_idle_fists[1])..","..tostring(playertwo_run_fists[timertwo_floored])..","..tostring(playertwo_attack_fists[timertwo_floored])..",")
  if timertwo_floored == 3 and timertwo > 3.9 then
    timertwo = 1
  end
  if timertwo_floored == 1 or timertwo_floored == 3 then
    playertwo.canAttack = true
  end
  if timertwo_floored == 1 and gameState == "player_2_wins" then

    if (playertwo.y + playertwo.height) >= groundLeveltwo-10 then -- When the player's height is around ground level and totalJumps == 0, set player's Y velocity to -820, causing the player to launch in the air.
      playertwo.yvel = -820
      playertwo.currentTexture = player_win[1]
    elseif playertwo.totalJumps == 0 then
      playertwo.totalJumps = 1
    end
  end
  --print(timertwo,timertwo_floored,playertwo.currentTexture)
  if not love.keyboard.isDown("left","up","right","rshift") then
    if playertwo.weapon == "fists" then
      playertwo.currentTexture = player_idle_fists[1]
    end
    if playertwo.weapon == "sword" then
      playertwo.currentTexture = player_idle_sword[timertwo_floored]
    end
  end
  if love.keyboard.isDown("left") then
    if playertwo.weapon == "fists" then
      scaleFactortwo = -playerScale
      playertwo.currentTexture = player_run_fists[timertwo_floored]
    end
    if playertwo.weapon == "sword" then
      scaleFactortwo = -playerScale
      playertwo.currentTexture = player_run_sword[timertwo_floored]
    end
  end
  if love.keyboard.isDown("right") then
    if playertwo.weapon == "fists" then
      scaleFactortwo = playerScale
      playertwo.currentTexture = player_run_fists[timertwo_floored]
    end
    if playertwo.weapon == "sword" then
      scaleFactortwo = playerScale
      playertwo.currentTexture = player_run_sword[timertwo_floored]
    end
  end
  if love.keyboard.isDown("rshift") and timertwo_floored < 3 then
    if playertwo.weapon == "fists" then
      playertwo.currentTexture = player_attack_fists[timertwo_floored]
      if playertwo.collided == true then
        --cPrint("HIYA!","player2.lua")
        if timertwo_floored == 2 and playertwo.canAttack then
          local critChance = love.math.random(0,4)
          if critChance == 4 then
            player.sendDamage(love.math.random(18,21))
          else
            player.sendDamage(15)
          end
           -- When attack animation 'attacks', send damage to opponent if they've collided with the player-
          playertwo.canAttack = false
        end
      end
    end
    if playertwo.weapon == "sword" then
      playertwo.currentTexture = player_attack_sword[timertwo_floored]
      if playertwo.collided == true then
        --cPrint("HIYA!","player1.lua")
        if timertwo_floored == 2 and playertwo.canAttack then
          player.sendDamage(25) -- When attack animation 'attacks', send damage to opponent if they've collided with the player-
          playertwo.canAttack = false
        end
      end
    end
  end
end
function playertwo.reset()
  playertwo.load()
end
function playertwo.sendDamage(damage)
  local rand2 = love.math.random(0,1000)
  local dmg = damage
  cPrint(rand2,"player2.lua")
  if opponentt.x < playertwo.x then
    if rand2 > 3 and rand2 < 7 then
      playertwo.xvel = 5500
      playertwo.yvel = -860
    else
      playertwo.xvel = 450
      playertwo.yvel = -350
    end

  else
    if rand2 > 3 and rand2 < 7 then
      playertwo.xvel = -5500
      playertwo.yvel = -860
    else
      playertwo.xvel = -450
      playertwo.yvel = -350
    end
  end
  if playertwo.god == false then
    cPrint("Player2: "..damage.." taken!","player2.lua")
    if player.weapon == "fists" and damage > 15 then
      addText("Critical! -"..damage.." HP",playertwo.x, playertwo.y)
    else
      addText("-"..damage.." HP",player.x,player.y)
    end
    playertwo.health = playertwo.health +-dmg
    if playertwo.health < 1 and playertwo.exploded == false then
      playertwo.exploded = true
      explodePlayer(playertwo.x,playertwo.y,parts,dt)
    end
  else
    cPrint("I am god. You cannot hurt me.","player2.lua")
  end
  cPrint("Remaining health: "..playertwo.health.."/100","player2.lua")
  cPrint("Opponent health: "..player.health.."/100","player2.lua")
end
function playertwo.physics(dt)
  --TODO: Physics might be a good idea. It's not space is it? It is? What.
  playertwo.x = playertwo.x + playertwo.xvel * dt
  playertwo.y = playertwo.y + playertwo.yvel * dt
  playertwo.yvel = playertwo.yvel + gravity * dt
  playertwo.xvel = playertwo.xvel * (1 - math.min(dt*playertwo.friction,1))
end
function playertwo.setOpponentPosition(x,y,w,h)
  opponentt.x = x
  opponentt.y = y
  opponentt.width = w
  opponentt.height = h
end
function playertwo.bounds()
  if not excollisions then
    if playertwo.x >= opponentt.x-50 and playertwo.x <= opponentt.x+50 then -- Checks if player is within opponent's bounding boxes.
      playertwo.collided = true -- If player is, allow them to take damage.
    else
      playertwo.collided=false -- Else, just don't bother with it.
    end
  else
    if playertwo.x >= opponentt.x-50 and playertwo.x <= opponentt.x+50 and playertwo.y+(playertwo.currentTexture:getHeight()*playerScale) >= opponentt.y and playertwo.y <= opponentt.y+(playertwo.currentTexture:getHeight()*playerScale)  then -- Checks if player is within opponent's bounding boxes.
      playertwo.collided = true -- If player is, allow them to take damage.
    else
      playertwo.collided = false -- Else, just don't bother with it.
    end
  end
  if playertwo.x > love.graphics.getWidth()+10 then
    playertwo.x = love.graphics.getWidth()+10
  end
  if playertwo.y + playertwo.height > groundLeveltwo then
    playertwo.y = groundLeveltwo-playertwo.height
    playertwo.yvel = 0
    playertwo.totalJumps = 0
    playertwo.inGround = true
  else
    playertwo.inGround = false
  end
end

function playertwo.update(dt)
  --TODO: Update everything.

  if focused == true then
    if playertwo.health >= 1 then
      playertwo.physics(dt)
      playertwo.bounds()
      playertwo.animate(dt)
      if spCMD == false then
        playertwo.movement(dt)
      end
    end --my suffering
  end
end

function playertwo.draw()
 --TODO: what
 if playertwo.health >= 1 then
   if nightMode == true and gameState ~= "player_2_wins" then
     love.graphics.setColor(playercol[1]/2,playercol[2]/2,playercol[3]/2,255)
   else
     love.graphics.setColor(playercol[1],playercol[2],playercol[3],255)
   end
   if rainbow then
     love.graphics.setColor(HSL(hue2,255,200))
   end
   if playertwo.currentTexture == nil then
     --cPrint("Player2 texture nil!! Just restart the game, or enter 'resetcharacters' in console.","WARNING")
     playertwo.currentTexture = player.textureIdle
   end
   love.graphics.draw(playertwo.currentTexture,playertwo.x,playertwo.y,0,scaleFactortwo,playerScale,playertwo.currentTexture:getWidth()/2,0)
   love.graphics.setColor(255,255,255,255)
 else
   if gameState ~= "main_menu" then
     gameState = "player_1_wins"
     nightMode = true
   end
 end

end

function playerUpdate(dt)
  playertwo.update(dt)
end
