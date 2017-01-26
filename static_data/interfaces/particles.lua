                    -- LEGAL NOTICE --
------------------
-- (C) LINUS 'NOTHY' RAMNEBORG 2017. ALL RIGHTS RESERVED.
-- NO REUSE ALLOWED. NO DISTRIBUTION OUTSIDE OF GAMEJOLT.COM ALLOWED.
-- DON'T BE STUPID, DON'T STEAL CODE.
-------------------
particles = {
  parts = {},
  xvel = {},
  yvel = {},
  gravity = (35*10),
  friction = {}
}
rotation = math.rad(0)
function explodePlayer(x,y,inP,dt)
  particles.parts = inP
  particles.xvel = {}
  particles.yvel = {}
  particles.x = {}
  particles.y = {}
  particles.gravity = (35*10)
  particles.friction = {}
  for k,v in ipairs(particles.parts) do
    particles.xvel[k] = love.math.random(-300,300)
    particles.yvel[k] = love.math.random(-700,500)
    particles.x[k] = x
    particles.y[k] = y
    particles.friction[k] = love.math.random(1,5)
  end
  --local xvel = love.math.random(-800,800)
  --local yvel = love.math.random(-1300,500)

end
function deleteParticles()
  particles.parts = {}
  particles.xvel = {}
  particles.yvel = {}
  particles.x = {}
  particles.y = {}
  particles.gravity = (33*10)
  particles.friction = {}
end
--playertwo.x = playertwo.x + playertwo.xvel * dt
--playertwo.y = playertwo.y + playertwo.yvel * dt
--playertwo.yvel = playertwo.yvel + gravity * dt
--playertwo.xvel = playertwo.xvel * (1 - math.min(dt*playertwo.friction,1))
function updateParticles(dt)
  if rotation > 360 then
    rotation = 0
  end
  rotation = math.rad(rotation + 30)
  physicsParticles(dt)
end
function physicsParticles(dt)
  if #particles.parts > 0 then
    for k,v in ipairs(particles.parts) do
      particles.x[k] = particles.x[k] + particles.xvel[k] * dt
      particles.y[k] = particles.y[k] + particles.yvel[k] * dt
      particles.yvel[k] = particles.yvel[k] + particles.gravity * dt
      particles.xvel[k] = particles.xvel[k] * (1-math.min(dt*particles.friction[k],1))
      if particles.y[k] > love.graphics.getHeight()+50 then
        table.remove(particles.parts,k)
        table.remove(particles.y,k)
        table.remove(particles.x,k)
        table.remove(particles.xvel,k)
        table.remove(particles.yvel,k)
        table.remove(particles.friction,k)
      end
    end
  end
end
function renderParticles(dt)
  if #particles.parts > 0 then
    for k,v in ipairs(particles.parts) do
      if k >= 1 and k <= 4 then
        love.graphics.draw(particles.parts[k],particles.x[k],particles.y[k],0,5,5)
      end
      if k > 4 then
        love.graphics.draw(particles.parts[k],particles.x[k],particles.y[k],0,3,3)
      end
    end
  end
end
