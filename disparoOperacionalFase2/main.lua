-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

system.activate("multitouch") -- Ativando MultiTouch

local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

composer.gotoScene( "inicio" )
--composer.gotoScene( "selectPlayer" )

