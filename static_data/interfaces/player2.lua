playertwo = {}
opponentt={
  width = 0,
  height = 0,
  x = 0,
  y = 0
}
groundLeveltwo = 458
gravitytwo = (35*100)
scaleFactortwo = 5
timertwo = 2
function playertwo.load(playerNumber)
  playertwo_idle_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png")
  }
  print("Loaded idle sprites for weapon: fists")
  playertwo_run_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_1.png"),
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_2.png"),
    love.graphics.newImage("static_data/textures/playerSprites/player_run_fists_3.png"),
  }
  print("Loaded running sprites for weapon: fists")
  playertwo_attack_fists = {
    love.graphics.newImage("static_data/textures/playerSprites/player_attack_fists.png")
  }
  print("Loaded attack sprites for weapon: fists")
  print("Finished loading.")
  --spritebatch = love.graphics.newSpriteBatch(love.graphics.newImage("static_data/textures/playerSprites/spriteAtlas.png"),20,"dynamic")
  playerNumber = nil --> Completely unimportant number, dunno why it's there when I'm doing object oriented programming. What the hell.
  playertwo.x = love.graphics.getWidth()-150 -->
  playertwo.y = 430 --> Literal X and Y coordinates for player.
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

  playertwo.collided = false
  --> Weapon stuff.
  playertwo.weapon = "fists"
end

function playertwo.hitReg(dt)
  --TODO: Figure out an efficient way to code the player hitreg
end

function playertwo.movement(dt)
  --TODO: Movement being very smooth. Like. Very, very smooth.
  if love.keyboard.isDown("right") and playertwo.xvel <  playertwo.speed then
    playertwo.xvel = playertwo.xvel + playertwo.speed * dt
  end
  if love.keyboard.isDown("left") and player.xvel >  -player.speed then
    playertwo.xvel = playertwo.xvel - playertwo.speed * dt
  end
  if love.keyboard.isDown("up") and playertwo.xvel <  playertwo.speed then
    if (playertwo.y + playertwo.height) >= groundLeveltwo-10 then
      playertwo.yvel = -650
    elseif playertwo.totalJumps == 0 then
      playertwo.totalJumps = 1
    end
  end

end
function playertwo.animate(dt) --> I'm not even sure how the hell this even works properly, but it works. So I'll keep it.
  timertwo = timertwo + 3 * dt    --> Whackjob, right? Riiiight? ..no?
  timertwo_floored = math.floor(timertwo)
  if timertwo_floored == 3 and timertwo > 3.9 then
    timertwo = 1
  end
  --print(timertwo,timertwo_floored,playertwo.currentTexture)
  if not love.keyboard.isDown("left","up","right") then
    if playertwo.weapon == "fists" then
      playertwo.currentTexture = playertwo_idle_fists[1]
    end
  end
  if love.keyboard.isDown("left") then
    if player.weapon == "fists" then
      scaleFactortwo = -5
      playertwo.currentTexture = playertwo_run_fists[timer_floored]
    end
  end
  if love.keyboard.isDown("right") then
    if playertwo.weapon == "fists" then
      scaleFactortwo = 5
      playertwo.currentTexture = playertwo_run_fists[timer_floored]
    end
  end
end
function playertwo.reset()
  playertwo.load()
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
  if playertwo.x >= opponentt.x-50 and playertwo.x <= opponentt.x+50 then
    if playertwo.x < opponentt.x then
      playertwo.x = opponentt.x-50
    else
      playertwo.x = opponentt.x+50
    end
  else
    player.collided = false
  end
  if playertwo.x < -10 then
    playertwo.x = -10
  end
  if playertwo.x > love.graphics.getWidth()+10 then
    playertwo.x = love.graphics.getWidth()+10
  end
  if playertwo.y + playertwo.height > groundLeveltwo then
    playertwo.y = groundLeveltwo-playertwo.height
    playertwo.yvel = 0
    playertwo.totalJumps = 0
  end
end

function playertwo.update(dt)
  --TODO: Update everything.
  playertwo.physics(dt)
  playertwo.bounds()
  playertwo.animate(dt)
  playertwo.movement(dt)
end

function playertwo.draw()
 --TODO: what
 love.graphics.setColor(100,255,100,255)
 love.graphics.draw(playertwo.currentTexture,playertwo.x,playertwo.y,0,scaleFactortwo,5,playertwo.currentTexture:getWidth()/2,0)
 love.graphics.setColor(255,255,255,255)
end

function playerUpdate(dt)
  playertwo.update(dt)
end
