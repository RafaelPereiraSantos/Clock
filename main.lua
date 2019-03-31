local clock = require ("classes.clock")
local widget = require ("classes.widget")
local object = require("classes.object")

local gc = love.graphics
local ms = love.mouse
local key = love.keyboard.isDown

local now = os.date("*t")

local ck01 = clock.new.analog_clock(now.hour, now.min, now.sec, 400, 300)
ck01.digital_version = true
widget.new(200, 200, 200, 200, ck01)

local ck02 = clock.new.analog_clock(now.hour, now.min, now.sec, 400, 300)
ck02.digital_version = true
widget.new(400, 400, 200, 200, ck02)

function love.load()
end

function love.update(dt)
  local left_click = ms.isDown("l")
  local right_click = ms.isDown("r")

  if key("escape") then
    love.event.quit()
  end

  widget.click_over(ms)
  widget.update(dt)

end

function love.draw()
  gc.clear()
  widget.draw(gc)
end

function love.mousepressed(x, y, button, istouch, presses)

end

function love.mousereleased(x, y, button, istouch, presses)

end