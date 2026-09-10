---------------------------------------------------------------------------
--
--  ScoreState.lua 
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

-- Extends BaseState (Inheritance)
ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

-- Handle state change
function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

-- Renders the score text
function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You Lost', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to play again', 0, 160, VIRTUAL_WIDTH, 'center')
end
