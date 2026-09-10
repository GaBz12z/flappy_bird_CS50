---------------------------------------------------------------------------
--
--  TitleScreenState.lua 
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

-- Extends BaseState
TitleScreenState = Class{__includes = BaseState}

-- If enter or return is pressed, change saveState to play
function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

-- Renders the 'menu'
function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
