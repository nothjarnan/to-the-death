
player = {}
opponent = {
  width = 0,
  height = 0,
  x = 0,
  y = 0
}
groundLevel = 458
gravity = (35*100)
scaleFactor = 5
timer = 1
function player.load(playerNumber)
  player_idle_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png") -- Load idle spriteset
  }
  cPrint("Loaded idle sprites for weapon: fists","player1.lua")
  player_run_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_1.png"), -- Load running spriteset
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_2.png"),
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_3.png"),
  }
  cPrint("Loaded running sprites for weapon: fists","player1.lua")
  player_attack_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/player_attack_fists2.png"),
    love.graphics.newImage("static_data/textures/playerSprites/player_attack_fists.png"), -- Load attack spriteset, which is kinda sucky.
    love.graphics.newImage("static_data/textures/playerSprites/player_attack_fists3.png"),
  }
  cPrint("Loaded attack sprites for weapon: fists","player1.lua") -- Tell ingame console (F5) this.
  cPrint("Finished loading.","player1.lua") -- Finished loading stuff.
  --spritebatch = love.graphics.newSpriteBatch(love.graphics.newImage("static_data/textures/playerSprites/spriteAtlas.png"),20,"dynamic")
  playerNumber = nil --> Completely unimportant number, dunno why it's there when I'm doing object oriented programming. What the hell.
  player.x = 150 -->
  player.y = 430 --> Literal X and Y coordinates for player.
  player.friction = 13 --> Air resistance/friction, used for calculating slowing down.
  player.speed = 2000 --> .. Top speed.
  player.xvel = 0 --> Player object's velocity in each direction
  player.yvel = 0 -->

  player.width = 35 -->
  player.height = 7 --> Not sure if these will be useless in a bit.
  player.textureIdle = {} --> TODO: Load textures for every weapon. (animation)
  player.totalJumps = 0 -- This is just for double jumping, therefor it's not used, as double jumping was removed in ALPHA 0.0.2
  player.textureIdle = love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png")
  player.currentTexture = player.textureIdle
  player.runTexture = {} -- Completely unused TODO: remove
  player.attackTexture = {} -- TODO: remove
  player.canAttack = true
  --> Physics (temp)
  player.collided = false -- FIXME: Add proper player collisions.
  --> Weapon stuff.
  player.weapon = "fists" -- Current weapon equipped. Defaults to Fists.
  player.health = 100 -- Player's health (double)
  player.god = false -- Godmode. Should probably be a local variable to prevent cheating with memory editors.
  player.parts = {
    love.graphics.newImage("static_data/textures/playerSprites/parts/player_arm.png"),
    love.graphics.newImage("static_data/textures/playerSprites/parts/player_body.png"),
    love.graphics.newImage("static_data/textures/playerSprites/parts/player_head.png"),
    love.graphics.newImage("static_data/textures/playerSprites/parts/player_legs.png"),
  }
  for i=4, 1500 do
    --cPrint(i,"DEBUG")
    player.parts[i] = love.graphics.newImage("static_data/textures/playerSprites/parts/bloodspot.png")
  end
end

function player.hitReg(dt)
  --TODO: Figure out an efficient way to code the player hitreg
end

function player.movement(dt)
  --TODO: Movement being very smooth. Like. Very, very smooth.
  if love.keyboard.isDown("d") and player.xvel <  player.speed then
    player.xvel = player.xvel + player.speed * dt -- When correct key is down, increment player's velocity by it's max speed times a time constant.
  end
  if love.keyboard.isDown("a") and player.xvel >  -player.speed then
    player.xvel = player.xvel - player.speed * dt
  end
  if love.keyboard.isDown("w") and player.xvel <  player.speed then
    if (player.y + player.height) >= groundLevel-10 then -- When the player's height is around ground level and totalJumps == 0, set player's Y velocity to -820, causing the player to launch in the air.
      player.yvel = -820
    elseif player.totalJumps == 0 then
      player.totalJumps = 1
    end
  end

end
function player.animate(dt) --> I'm not even sure how the hell this even works properly, but it works. So I'll keep it.
  timer = timer + 3 * dt    --> Whackjob, right? Riiiight? ..no?
  timer_floored = math.floor(timer)
  if timer_floored == 3 and timer > 3.9 then
    timer = 1 -- This timer is made for timing the animation, hence why it is almost always ticking. Timer can be stopped when it is not called in player.update(dt)
  end
  if timer_floored == 1 or timer_floored == 3 then
    player.canAttack = true
  end
  --cPrint(timer,timer_floored,player.currentTexture)
  if not love.keyboard.isDown("w","a","d","lshift") then -- Check if the keys for movement & attacking is down, if not, check weapon and play idle animation for specified weapon.
    if player.weapon == "fists" then
      player.currentTexture = player_idle_fists[1]
    end
  end
  if love.keyboard.isDown("a") then
    if player.weapon == "fists" then
      scaleFactor = -5
      player.currentTexture = player_run_fists[timer_floored]
    end
  end
  if love.keyboard.isDown("d") then
    if player.weapon == "fists" then
      scaleFactor = 5
      player.currentTexture = player_run_fists[timer_floored]
    end
  end
  if love.keyboard.isDown("lshift") and timer_floored < 3 then
    if player.weapon == "fists" then
      player.currentTexture = player_attack_fists[timer_floored]
      if player.collided == true then
        cPrint("HIYA!","player1.lua")
        if timer_floored == 2 and player.canAttack then
          playertwo.sendDamage(10) -- When attack animation 'attacks', send damage to opponent if they've collided with the player-
          player.canAttack = false
        end
      end
    end
  end
end
function player.reset()
  player.load() -- Calls the load function to 'reset' the players. Stupid, but it works.
end
function player.sendDamage(damage)
  local dmg = damage -- Set dmg variable to damage (specified in function)
  local rand = love.math.random(0,1000)
  cPrint(rand,"player.lua")
  if opponent.x < player.x then
    if rand > 3 and rand < 7 then
      player.xvel = 5500
      player.yvel = -860
    else
      player.xvel = 350
      player.yvel = -350
    end
  else
    if rand > 3 and rand < 7 then
      player.xvel = -5500
      player.yvel = -860
    else
      player.xvel = -350
      player.yvel = -350
    end
  end

  if player.god == false then -- If the player doesn't have godmode, allow player to take damage from opponent
    cPrint("Player1: "..damage.." taken!","player1.lua")
    player.health = player.health +-dmg
    if player.health < 0 then
      explodePlayer(player.x,player.y,player.parts,dt)
    end
  else
    cPrint("I am god! Opponent cannot damage me.","player1.lua") -- Else, mock the player in console (F5).
  end
  cPrint("Remaining health: "..player.health.."/100","player1.lua") -- Slap out remaining health in console.
  cPrint("Opponent health: "..playertwo.health.."/100","player1.lua")
end
function player.physics(dt)
  --TODO: Physics might be a good idea. It's not space is it? It is? What.
  player.x = player.x + player.xvel * dt
  player.y = player.y + player.yvel * dt
  player.yvel = player.yvel + gravity * dt
  player.xvel = player.xvel * (1 - math.min(dt*player.friction,1))

end
function player.setOpponentPosition(x,y,w,h)
  opponent.x = x
  opponent.y = y
  opponent.width = w
  opponent.height = h
end
ab = false
function player.bounds()
  if player.x >= opponent.x-50 and player.x <= opponent.x+50 then -- Checks if player is within opponent's bounding boxes.
    player.collided = true -- If player is, allow them to take damage.
  else
    player.collided=false -- Else, just don't bother with it.
  end

  if player.x < -10 then -- Check that player doesn't go outside of view.
    player.x = -10
  end
  if player.x > love.graphics.getWidth()+10 then
    player.x = love.graphics.getWidth()+10 -- Again, make sure that they don't. Ever.
  end
  if player.y + player.height > groundLevel then
    player.y = groundLevel-player.height -- This is just for stopping the player when they land after jumping. It's just a matter of setting their y velocity to 0. Fuck gravity.
    player.yvel = 0
    player.totalJumps = 0
  end
end

function player.update(dt)
  --TODO: Update everything.
  if focused == true then
    if player.health >= 0 then -- If the player's health is above 0, update everything. Else, the player is probably dead. So don't update or render the player.
      player.physics(dt)
      player.bounds()
      player.animate(dt)
      if spCMD == false then
        player.movement(dt) -- For the commandline, if the console is open, don't allow the players to move. Essentially pause the game.
      end
    end
  end
end

function player.draw()
 --TODO: what
 if player.health >= 0 then
   if rainbow then
     love.graphics.setColor(HSL(hue2,255,200))
   end
   love.graphics.draw(player.currentTexture,player.x,player.y,0,scaleFactor,5,player.currentTexture:getWidth()/2,0) -- Draw the player at their X and Y cordinates, with an offset of 50% of their texture width.
 else
  if gameState ~= "main_menu" then
     gameState = "player_2_wins" -- Check if gamestate is not main menu, if it's not, and player's health is less than or equal to 0, announce that opponent won.
     nightMode = true
  end
 end
end

function playerUpdate(dt)
  player.update(dt) -- Update player, This function gets called in main.lua
end
