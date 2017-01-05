
player = {}

function player.load(playerNumber)
  playerNumber = nil --> Completely unimportant number, dunno why it's there when I'm doing object oriented programming. What the hell.
  player.x = 0 -->
  player.y = 0 --> Literal X and Y coordinates for player.
  player.friction = 8.2 --> Air resistance/friction, used for calculating slowing down.
  player.speed = 1981.3 --> .. Top speed.
  player.xvel = 0 --> Player object's velocity in each direction
  player.yvel = 0 -->

  player.width = 5 -->
  player.height = 7 --> Not sure if these will be useless in a bit.
  player.textureIdle = {
    
  }
  player.runTexture = {}
  player.attackTexture = {}
end

function player.hitReg(dt)
  --TODO: Figure out an efficient way to code the player hitreg
end

function player.movement(dt)
  --TODO: Movement being very smooth. Like. Very, very smooth.

end

function player.physics(dt)
  --TODO: Physics might be a good idea. It's not space is it? It is? What.

end

function player.update(dt)
  --TODO: Update everything.
end

function player.draw()
 --TODO: what
end

function playerUpdate(dt)
  player.update(dt)
end
