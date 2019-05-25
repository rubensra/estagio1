
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- MODULOS ---------------------------------------------------------------------------
local som = require("src.audio.sons")

--------------------------------------------------------------------------------------
local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local function gotoSelect()
	composer.gotoScene( "selectPlayer", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	sceneGroup:insert( backGroup )
	sceneGroup:insert( mainGroup )
	sceneGroup:insert( uiGroup )
	local fundo = display.newImageRect( backGroup, "images/inicio/Tela_Inicial.png", 320, 480 )
	fundo.x = display.contentCenterX
	fundo.y = display.contentCenterY

	local areaToque = display.newRect( mainGroup, display.contentCenterX, display.contentCenterY+180, 320, 150 )
	areaToque.alpha = 0.1
	areaToque:addEventListener( "tap", gotoSelect )
	
	local texto = {}
	local tamanhoTexto = 25
	local mensagemText = display.newText(uiGroup, "Disparo Operacional", display.contentCenterX, display.contentCenterY-50, native.systemFont, tamanhoTexto )
	mensagemText:setFillColor(0,0,0)
	--mensagemText.fill.effect = "filter.posterize"
	local sombraMensagemText = display.newText(uiGroup, "Disparo Operacional", display.contentCenterX+tamanhoTexto/10, display.contentCenterY-50+tamanhoTexto/10, native.systemFont, tamanhoTexto )
	sombraMensagemText:setFillColor(1,1,1)
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		--audio.play(musicaFundo, {channel = 1, loops = -1 } )
		som.somTema();
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		som.onClose();
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene("inicio")
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
