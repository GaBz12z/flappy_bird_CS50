---------------------------------------------------------------------------
--
--  BaseState.lua 
--
--  URL: https://github.com/GaBz12z/flappy_bird_CS50
--
---------------------------------------------------------------------------

BaseState = Class{}

--[[
    Place Holder functions so StateMachine doesnt break when it calls a class that doesnt have certain function
]]
function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end