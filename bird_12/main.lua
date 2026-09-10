---------------------------------------------------------------------------
--
--  main.lua - Adding mouse input do jump
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

-- transform.rotation = Quaternion.Euler(0, 0, rb.velocity.y * rotationSpeed);

push = require 'push'

Class = require 'class'

require 'Bird'

require 'Pipe'

require 'PipePair'

require 'StateMachine'
require 'states.BaseState'
require 'states.PlayState'
require 'states.ScoreState'
require 'states.CountdownState'
require 'states.TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Ground and background starting scroll location on the x-axis
local backgroundScroll_2 = 0
local backgroundScroll = 0
local groundScroll = 0

-- Speed at which the sprites will move
local BACKGROUND_2_SCROLL_SPEED = 25
local BACKGROUND_SCROLL_SPEED = 35
local GROUND_SCROLL_SPEED = 50

-- Dimension in the sprite where the code loops the background 
local BACKGROUND_LOOPING_POINT = 288
local BACKGROUND_2_LOOPING_POINT = 288

function love.load()
    -- Point filtering
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    background_2 = love.graphics.newImage('images/background-2.png')
    background = love.graphics.newImage('images/background.png')
    ground = love.graphics.newImage('images/ground.png')

    love.window.setTitle('Flappy Bird in Lua')

    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    -- Create the virtual canvas
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    
    --[[
        Global sound table with all sounds
    ]]
    gSounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
    }

    -- Start music
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    --[[
        Global state machine that is initialize and return functions onthe saveState class
    ]]
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- Initialize input table, you can add any table that you want
    love.keyboard.keysPressed = {}

    -- Initialize input table to mouse input
    love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    -- Add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    Love2D callback fired each time a mouse button is pressed, gives the x and y of where the mouse clicked
]]
function love.mousepressed(x,y , button)
    love.mouse.buttonsPressed[button] = true
end

--[[
    Used to store any key that is fired at that frame, is a extensions inside love.keyboard space
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--[[
    Equivalent to our keyboard function from before, but for the mouse buttons.
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end


function love.update(dt)
    --[[
        Parallax values that changes each frame and advances a little until it reaches a certain value and resets to 0 in the image
    ]]
    backgroundScroll_2 = (backgroundScroll_2 + BACKGROUND_2_SCROLL_SPEED * dt) % BACKGROUND_2_LOOPING_POINT

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

    -- The StateMachine deals with the update of all states in its class
    gStateMachine:update(dt)

    -- Reset input table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:apply('start')

    --[[
        We draw our images shifted to the left by their looping point, eventually they will revert to 0 once both values in % are equal, the division will be = 0 and the images will be reverted to their x = 0
    ]]
    -- Draw the background at the negative looping point
    love.graphics.draw(background_2, -backgroundScroll_2, 0)

    -- Draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    --[[
        We render the background outside the StateMachine because the background is always visible, any other process are dealt by the state machine
    ]]
    gStateMachine:render()
 
    -- Draw the ground on top of the background, towards the bottom of the screen, at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:apply('end')
end