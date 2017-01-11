local timers = {}
local texts = {}
local textsx = {}
local textsy = {}
local font = love.graphics.newFont(25)
function updateTexts(dt)
  if #timers > 0 then
    for k,v in ipairs(timers) do
      timers[k] = timers[k] - 100 * dt
      textsy[k] = textsy[k] - 45 * dt
      if timers[k] < -10 then
        table.remove(timers,k)
        table.remove(texts,k)
        table.remove(textsx,k)
        table.remove(textsy,k)
      end
    end
  end
end
function addText(text,x,y)
  texts[#texts+1] = text
  textsx[#textsx+1] = x
  textsy[#textsy+1] = y
  timers[#timers+1] = 255
end
function renderText()
  if #texts > 0 and #timers > 0 then
    for k,v in ipairs(texts) do
      love.graphics.setFont(font)
      love.graphics.setColor(255,255,255,timers[k])
      love.graphics.print(v,textsx[k],textsy[k])
      love.graphics.setColor(255,255,255,255)
      love.graphics.setFont(gamefont)
    end
  end
end
