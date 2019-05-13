
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

local function gotoInicio()
	composer.gotoScene( "inicio", { time = 800, effect="crossFade" } )
end

-- CARREGANDO MODULOS --------------------------------------------------------

local som = require("src.audio.sons")
local imagens = require("src.carregarImagens")
local uiDisp = require("src.uiDisplay")


local replayButton
local fundo
-------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	sceneGroup:insert(backGroup);
	sceneGroup:insert(mainGroup);
    sceneGroup:insert(uiGroup);
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-------------------------------------------------------------------------------------
	fundo = imagens.carregarFundo("fim",backGroup) --display.newImageRect( sceneGroup, "images/circuito00_320x480.png", 320, 480 )
	
	-------------------------------------------------------------------------------------
	replayButton = uiDisp.Mensagem(uiGroup,"derrota")
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		replayButton:addEventListener("tap", gotoInicio );

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		som.GameOver();
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("tap",replayButton);
		composer.removeScene( "fimJogo" );

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
