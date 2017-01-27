achievement = {}
local currentTrophy = {}
local trophiesToDraw = {}
local trophiesXY = {}
local trophiesTimer = {}
local trophybody = love.grahics.newImage("static_data/textures/icons/achievementbody.png")
function achievement.get(id)
  currentTrophy[#currentTrophy+1] = GJ.fetchTrophy(id)
  if currentTrophy[#currentTrophy].achieved == "false" then
    local success = GJ.giveTrophy(id)
    if success == true then
      trophiesToDraw[#trophiesToDraw+1] = currentTrophy.name
      trophiesXY[#trophiesXY+1].x = -150
      trophiesXY[#trophiesXY+1].y = 50
      trophiesTimer[#trophiesTimer+2].time = 0
    end
  end
end

function achievement.update()
  for k,v in ipairs(trophiesToDraw) do

  end
end
function achievement.draw()
  for k,v in ipairs(trophiesToDraw) do
    love.graphics.draw()
  end
end
