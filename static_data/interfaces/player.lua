
player = {}

function player.load(playerNumber)
  --spritebatch = love.graphics.newSpriteBatch(love.graphics.newImage("static_data/textures/playerSprites/spriteAtlas.png"),20,"dynamic")
  playerNumber = nil --> Completely unimportant number, dunno why it's there when I'm doing object oriented programming. What the hell.
  player.x = 0 -->
  player.y = 0 --> Literal X and Y coordinates for player.
  player.friction = 8.2 --> Air resistance/friction, used for calculating slowing down.
  player.speed = 1981.3 --> .. Top speed.
  player.xvel = 0 --> Player object's velocity in each direction
  player.yvel = 0 -->

  player.width = 5 -->
  player.height = 7 --> Not sure if these will be useless in a bit.
  player.textureIdle = {} --> TODO: Load textures for every weapon. (animation)
  player.playerHolderTex = love.graphics.newImage("static_data/textures/playerSprites/guy_idle_.png")
  player.runTexture = {}
  player.attackTexture = {}
end

function player.hitReg(dt)
  --TODO: Figure out an efficient way to code the player hitreg
end

function player.movement(dt)
  --TODO: Movement being very smooth. Like. Very, very smooth.
  if love.keyboard.isDown("d") and player.xvel <  player.speed then
    player.xvel = player.xvel + player.speed * dt
  end
  if love.keyboard.isDown("a") and player.xvel <  player.speed then
    player.xvel = player.xvel - player.speed * dt
  end
  if love.keyboard.isDown("w") and player.xvel <  player.speed then
    player.yvel = player.yvel + player.speed * dt
  end

end

function player.physics(dt)
  --TODO: Physics might be a good idea. It's not space is it? It is? What.
  player.x = player.x + player.xvel * dt
  player.y = player.y + player.yvel * dt
  player.xvel = player.xvel * (1 - math.min(dt*player.friction,1))

end

function player.update(dt)
  --TODO: Update everything.
  player.physics(dt)
  player.movement(dt)
end

function player.draw()
 --TODO: what
 love.graphics.draw(player.playerHolderTex,player.x,player.y,0,5,5,0,0)
end

function playerUpdate(dt)
  player.update(dt)
end
