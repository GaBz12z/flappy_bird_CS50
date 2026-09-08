---------------------------------------------------------------------------
--
--  PipePair.lua - Spawning pipes and despawning them
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

PipePair = Class{}

GAP_HEIGHT = 90

function PipePair:init(y)
    -- Initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    self.y = y

    -- Instantiate a pair of pipes 
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false
end

function PipePair:update(dt)
    --[[
        Remove the pipe if its beyond the left edge + PIPE_WIDTH, else kee moving from right to left
    ]]
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end


