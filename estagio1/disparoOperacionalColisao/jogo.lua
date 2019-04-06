
local composer = require( "composer" )

local scene = composer.newScene()

math.randomseed( os.time() )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
system.activate("multitouch") -- Ativando MultiTouch

local _W = display.contentWidth -- Largura total da Tela
local _H = display.contentHeight -- Altura total da Tela
local scrollSpeed = 1 -- Velocidade de movimento do fundo

local died = false -- Variavel para controlar as mortes do jogador

local aliensTable = {} -- Tabela p/ guardar as naves aliens criadas

local nave -- Variavel para referenciar a Nave

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local physics = require( "physics" ) -- Carregando modulo de fisica do sistema
physics.start() -- Iniciando a fisica
physics.setGravity( 0 , 0 ) -- Ajustando gravidade para Zero 

-- Criando e carregando as imagens de fundo para o efeito de movimento --
local fundo = display.newImageRect( backGroup, "images/circuito00_320x480.png", 320, 480 )
fundo.x = display.contentCenterX 
fundo.y = display.contentCenterY
fundo.xScale = 1.0 
fundo.yScale = 1.0

local fundo2 = display.newImageRect( backGroup, "images/circuito00_320x480.png", 320, 480 )
fundo2.x = display.contentCenterX
fundo2.y = display.contentCenterY - display.actualContentHeight
fundo2.xScale = 1.0
fundo2.yScale = 1.0



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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
