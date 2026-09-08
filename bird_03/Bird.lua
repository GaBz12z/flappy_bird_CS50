---------------------------------------------------------------------------
--
--  Bird.lua
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

Bird = Class{}

local GRAVITY = 980

function Bird:init()
    -- Load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity
    self.dy = 0
end

function Bird:update(dt)
    -- Apply gravity to velocity in Y-axis
    self.dy = self.dy + GRAVITY * dt

    -- Apply gravity through the velocity in dy
    self.y = self.y + self.dy * dt
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end