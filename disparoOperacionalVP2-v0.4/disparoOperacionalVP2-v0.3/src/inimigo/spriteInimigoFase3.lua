
local spriteInimigo = {}

local nave

local inimigoSheetOptions = 
{
    frames = {
    
        {
            -- 1) Cavalo Troia 200x200
            x=0,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 2) email aberto - 150x200
            x=200,
            y=0,
            width=150,
            height=200,
        },
        {
            -- 3) email fechado - 100x200
            x=350,
            y=0,
            width=100,
            height=200,
        },
        {
            -- 4) blackHat - 200x120
            x = 450,
            y = 0,
            width = 200,
            height = 120,
        },
        {
            -- 5) ping da morte - 100x200
            x=650,
            y=0,
            width=100,
            height=200,
        },
        {
            -- 6) spam - 100x200
            x=750,
            y=0,
            width=100,
            height=200,
        },
    },
}
-- Carregando a folha de imagens --
local inimigoSheet = graphics.newImageSheet( "images/fase03/inimigos/inimigosFase03.png", inimigoSheetOptions )
--------------------------------------------------------------------------------------
local disparoSheetOptions = 
{
    frames = {

        { -- Cookie
            x = 0,
            y = 0,
            width = 140,
            height = 200,
        },
        { -- Bomba
            x = 140,
            y = 0,
            width = 200,
            height = 180,
        },
    },
}
local disparoSheet = graphics.newImageSheet("images/fase03/inimigos/inimigosFase3Disparos.png", disparoSheetOptions)


function spriteInimigo.carregarInimigo(grupo,tipo)
  
    if (tipo ~= 1 ) then
        return display.newImageRect( grupo, inimigoSheet, tipo, 50, 60 )
    else
        return display.newImageRect( grupo, inimigoSheet, tipo, 100, 120 )
    end
end

function spriteInimigo.carregarTiro(grupo, tipo)
   
    if( tipo == 2 )then
        return display.newImageRect( grupo, disparoSheet, tipo, 50, 60 )
    elseif( tipo == 1 ) then
        return display.newImageRect( grupo, disparoSheet, tipo, 100, 200 )
    end
end

return spriteInimigo