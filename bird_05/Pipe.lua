---------------------------------------------------------------------------
--
--  Pipe.lua
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = VIRTUAL_WIDTH

    -- Every pipe will have a random Y value
    self.y = math.random(VIRTUAL_HEIGHT / 2, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
