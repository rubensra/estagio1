
local composer = require( "composer" )

local scene = composer.newScene()

local function irSelecao1()
	local nave = { nome="Janela"}
	composer.gotoScene( "game2", { time=800, effect="crossFade", params=nave } )
end

local function irSelecao2()
	local nave = {nome="maca"}
	composer.gotoScene(  "game2", { time=800, effect="crossFade", params=nave } )
end

local function irSelecao3()
	local nave = { tipoNave = "pinguim" , totalVidas = 2, totalScore = 0, totalMunicao = 10 }--{nome="pinguim"}
	composer.gotoScene(  "fase2", { time=800, effect="crossFade", params=nave } )
end

local musicaFundo = audio.loadSound("audio/Intro_Tema.wav")

local function onClose( event )
    audio.stop();
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local naveSheetOptions = 
{
    frames = {
    
        {
            -- nave_pinguim-70x80
            x=0,
            y=0,
            width=70,
            height=80,
        },
        {
            -- nave_janela-70x80
            x=70,
            y=0,
            width=70,
            height=80,
        },
        {
            -- nave_maça-70x80
            x=140,
            y=0,
            width=70,
            height=80,
        },
        {
            -- raio_nave_pinguim-15x80
            x=210,
            y=0,
            width=15,
            height=80,
        },
        {
            -- raio_nave_janela-15x80
            x=225,
            y=0,
            width=15,
            height=80,
        },
        {
            -- raio_nave_maça-15x80
            x=240,
            y=0,
            width=15,
            height=80,
        },
    },
}
-- Carregando a folha de imagens --
local naveSheet = graphics.newImageSheet( "images/herois.png", naveSheetOptions )



local backGroup = display.newGroup();
local mainGroup = display.newGroup();
local uiGroup = display.newGroup()
	
local textJanela = display.newText( uiGroup, "Disparos Infinitos\n e Escudo", display.contentCenterX+35, 86, native.systemFontBold, 12 );
textJanela:setFillColor(0,0,0)
local textMaca = display.newText( uiGroup, "Disparos Recarregaveis\n e Escudo", display.contentCenterX+35, 245, native.systemFontBold, 12 );
textMaca:setFillColor(0,0,0)
local textPinguim = display.newText( uiGroup, "Disparos Recarregavei", display.contentCenterX+35, 395, native.systemFontBold, 12 );
textPinguim:setFillColor(0,0,0)

local fundo = display.newImageRect(backGroup, "images/circuito00_320x480.png", 320, 480 );
fundo.x = display.contentCenterX;
fundo.y = display.contentCenterY;
local pinguim = display.newImageRect( mainGroup, naveSheet, 1, 70, 80 );
pinguim.myName = "pinguim";
local maca = display.newImageRect( mainGroup, naveSheet, 3, 70, 80 );
maca.myName = "maca";
local janela = display.newImageRect( mainGroup, naveSheet, 2, 70, 80 );
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
        audio.play(musicaFundo, { channel = 1, loops = -1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
        onClose();
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
