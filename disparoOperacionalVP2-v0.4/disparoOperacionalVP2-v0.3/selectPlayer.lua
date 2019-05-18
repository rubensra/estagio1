
local composer = require( "composer" )

local scene = composer.newScene()


-- MODULOS ---------------------------------------------------------------------------
local som = require("src.audio.sons")
local imagens = require("src.carregarImagens")
local transicao = require("src.fases.fases")
--------------------------------------------------------------------------------------

local function irSelecao1()
	local nave = { tipoNave = 2, totalVidas = 3, totalScore = 0, totalMunicao = 99 }
	--composer.gotoScene( "fase1", { time=800, effect="crossFade", params=nave } )
	transicao.gotoFase1(nave)
end

local function irSelecao2()
	local nave = { tipoNave = 3, totalVidas = 2, totalScore = 0, totalMunicao = 10, fim = false }
	--composer.gotoScene(  "fase3", { time=800, effect="crossFade", params=nave } )
	transicao.gotoFase3(nave)
end

local function irSelecao3()
	local nave = { tipoNave = 1, totalVidas = 3, totalScore = 0, totalMunicao = 10, fim = false }
	--composer.gotoScene(  "fase2", { time=800, effect="crossFade", params=nave } )
	transicao.gotoFase2(nave)
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local backGroup = display.newGroup();
local mainGroup = display.newGroup();
local uiGroup = display.newGroup()
	
local textJanela = display.newText( uiGroup, "Disparos Infinitos\n e Escudo", display.contentCenterX+35, 86, native.systemFontBold, 12 );
textJanela:setFillColor(0,0,0)
local textMaca = display.newText( uiGroup, "Disparos Recarregaveis\n e Escudo", display.contentCenterX+35, 245, native.systemFontBold, 12 );
textMaca:setFillColor(0,0,0)
local textPinguim = display.newText( uiGroup, "Disparos Recarregavei", display.contentCenterX+35, 395, native.systemFontBold, 12 );
textPinguim:setFillColor(0,0,0)

local fundo = imagens.carregarFundo(1,backGroup)--display.newImageRect(backGroup, "images/fase01/fundo/circuito00_320x480.png", 320, 480 );
fundo.x = display.contentCenterX;
fundo.y = display.contentCenterY;
local pinguim = imagens.carregarHeroi(mainGroup,1)--herois.carregarHeroi(mainGroup,1)--display.newImageRect( mainGroup, naveSheet, 1, 70, 80 );
pinguim.myName = "pinguim";
local maca = imagens.carregarHeroi( mainGroup,3);
maca.myName = "maca";
local janela = imagens.carregarHeroi(mainGroup,2);
janela.myName = "Janela";

maca.x = display.contentWidth / 4;
maca.y = 245;
janela.x = display.contentWidth / 4;
janela.y = 86;
pinguim.x = display.contentWidth / 4;
pinguim.y = 395;


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
	janela:addEventListener("tap", irSelecao1 );
	maca:addEventListener("tap", irSelecao2);
	pinguim:addEventListener("tap", irSelecao3);

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
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
