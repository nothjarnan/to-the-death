
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
    love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png")
  }
  print("Loaded idle sprites for weapon: fists")
  player_run_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_1.png"),
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_2.png"),
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_3.png"),
  }
  print("Loaded running sprites for weapon: fists")
  player_attack_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/player_attack_fists.png")
  }
  print("Loaded attack sprites for weapon: fists")
  print("Finished loading.")
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
  player.totalJumps = 0
  player.textureIdle = love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png")
  player.currentTexture = player.textureIdle
  player.runTexture = {}
  player.attackTexture = {}

  --> Physics (temp)
  player.collided = false
  --> Weapon stuff.
  player.weapon = "fists"
end

function player.hitReg(dt)
  --TODO: Figure out an efficient way to code the player hitreg
end

function player.movement(dt)
  --TODO: Movement being very smooth. Like. Very, very smooth.
  if love.keyboard.isDown("d") and player.xvel <  player.speed then
    player.xvel = player.xvel + player.speed * dt
  end
  if love.keyboard.isDown("a") and player.xvel >  -player.speed then
    player.xvel = player.xvel - player.speed * dt
  end
  if love.keyboard.isDown("w") and player.xvel <  player.speed then
    if (player.y + player.height) >= groundLevel-10 then
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
    timer = 1
  end
  --print(timer,timer_floored,player.currentTexture)
  if not love.keyboard.isDown("w","a","d") then
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
  if love.keyboard.isDown("rightShift") then
    if player.weapon == "fists" then
      player.currentTexture = player_attack_fists[1]
    end
  end
end
function player.reset()
  player.load()
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

function player.bounds()
  if player.y >= opponent.y then
    -- uh idk? don't ask me wtf.
  else
    if player.x >= opponent.x-50 and player.x <= opponent.x+50 then
      if player.x < opponent.x then
        player.x = opponent.x-50
      else
        player.x = opponent.x+50
      end
    else
      player.collided = false
    end
  end


  if player.x < -10 then
    player.x = -10
  end
  if player.x > love.graphics.getWidth()+10 then
    player.x = love.graphics.getWidth()+10
  end
  if player.y + player.height > groundLevel then
    player.y = groundLevel-player.height
    player.yvel = 0
    player.totalJumps = 0
  end
end

function player.update(dt)
  --TODO: Update everything.
  player.physics(dt)
  player.bounds()
  player.animate(dt)
  player.movement(dt)
end

function player.draw()
 --TODO: what
 love.graphics.draw(player.currentTexture,player.x,player.y,0,scaleFactor,5,player.currentTexture:getWidth()/2,0)
end

function playerUpdate(dt)
  player.update(dt)
end
