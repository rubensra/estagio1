
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

--[[ Criando e carregando as imagens de fundo para o efeito de movimento --
local fundo = display.newImageRect( sceneGroup, "images/circuito00_320x480.png", 320, 480 )
fundo.x = display.contentCenterX 
fundo.y = display.contentCenterY
fundo.xScale = 1.0 
fundo.yScale = 1.0]]--

local function gotoInicio()
	composer.gotoScene( "inicio", { time = 800, effect="crossFade" } )
end

local fimDeJogo = audio.loadSound("audio/fimDeJogo.mp3")

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-------------------------------------------------------------------------------------
	local fundo = display.newImageRect( sceneGroup, "images/circuito00_320x480.png", 320, 480 )
	fundo.x = display.contentCenterX 
	fundo.y = display.contentCenterY
	fundo.xScale = 1.0 
	fundo.yScale = 1.0
	-------------------------------------------------------------------------------------
	local mensagemText = display.newText(sceneGroup, "VOCE PERDEU!!!", display.contentCenterX, display.contentCenterY, native.systemFont, 20 )
	mensagemText.alpha = 0;
	transition.to(mensagemText, {alpha = 1 } )
	audio.play(fimDeJogo, { channel = 1, loops = 1 } )
	local replayButton = display.newText( sceneGroup, "Toque pra Rejogar", display.contentCenterX, display.contentCenterY + 50, native.systemFont, 20 );
	replayButton:setFillColor( 1, 1, 1)
	replayButton.alpha = 0;
	transition.to( replayButton, { alpha = 1 } );
	replayButton:addEventListener("tap", gotoInicio )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--fundo:addEventListener( "tap", gotoInicio )
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
			composer.removeScene( "fimJogo" )
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
