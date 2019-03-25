local clock = require("clock")

local g = love.graphics

local ck01 = clock.new(1, 30, 20, 400, 300)

function love.load()
end

function love.update(dt)
  ck01:update(dt)
end

function love.draw()
  g.clear()
  ck01:draw(g)
end