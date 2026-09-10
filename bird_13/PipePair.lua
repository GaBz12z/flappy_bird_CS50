---------------------------------------------------------------------------
--
--  PipePair.lua 
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

PipePair = Class{}

function PipePair:init(y, gap_height)
    -- Initialize pipes past the end of the screen
    self.x = VIRTUAL_WIDTH + 32

    self.y = y

    -- Instantiate a pair of pipes 
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + gap_height)
    }

    self.remove = false
end

function PipePair:update(dt)
    --[[
        If self.x is bigger than -PIPE_WIDTH (if the pipe is on screen), update then self.x to make them move right to left and copy this value to both parts of the pipe, if the pipe isn't on screen, delete them
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


