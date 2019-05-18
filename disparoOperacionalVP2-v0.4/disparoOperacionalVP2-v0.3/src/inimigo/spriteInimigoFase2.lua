
local spriteInimigo = {}

local nave

local inimigoSheetOptions = 
{
    frames = {
    
        {
            -- 1) besouro Amarelo 200x200
            x=0,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 2) besouro Azul-200x200
            x=200,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 3) ladyBug -200x200
            x=400,
            y=0,
            width=200,
            height=200,
        },
        {
            -- 4) Chefe Maripos 200x200
            x = 600,
            y = 0,
            width = 200,
            height = 200,
        },
        {
            -- 5) nuvem Amarela - 100x200
            x=800,
            y=0,
            width=100,
            height=200,
        },
        {
            -- 6) nuvem Azul - 100x200
            x=900,
            y=0,
            width=100,
            height=200,
        },
        {
            -- 7) nuvem Cinza - 100x200
            x=1000,
            y=0,
            width=100,
            height=200,
        },
    },
}
-- Carregando a folha de imagens --
local inimigoSheet = graphics.newImageSheet( "images/fase02/inimigos/inimigosFase2.png", inimigoSheetOptions )


function spriteInimigo.carregarInimigo(grupo,tipo)
  
    if (tipo ~= 4 ) then
        return display.newImageRect( grupo, inimigoSheet, tipo, 50, 60 )
    else
        return display.newImageRect( grupo, inimigoSheet, tipo, 100, 120 )
    end
end

function spriteInimigo.carregarTiro(grupo, tipo)
   
    if( tipo <= 2 )then
        return display.newImageRect( grupo, inimigoSheet, tipo+4, 100, 200 )
    elseif( tipo == 4 ) then
        return display.newImageRect( grupo, inimigoSheet, tipo+3, 100, 200 )
    end
end

return spriteInimigo