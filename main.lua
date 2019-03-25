local clock = require("clock")

local g = love.graphics

local now = os.date("*t")

local ck01 = clock.new(now.hour, now.min, now.sec, 400, 300)

function love.load()
end

function love.update(dt)
  ck01:update(dt)
end

function love.draw()
  g.clear()
  ck01:draw(g)
end