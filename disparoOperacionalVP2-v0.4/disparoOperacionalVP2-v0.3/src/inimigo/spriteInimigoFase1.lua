local spriteInimigo = {}


-- Folha de imagens das naves aliens --
local inimigoSheetOptions = 
{
    frames = {
    
       {
            -- nave 1 - Chefe
            x = 0,
            y = 0,
            width = 100,
            height = 120,
        },
        {
            -- nave 2 - Verde
            x = 0,
            y = 120,
            width = 70,
            height = 80,
        },
        {
            -- nave 3 - laranja
            x = 0,
            y = 200,
            width = 70,
            height = 80,
        },
        {
            -- nave 4 - roxo
            x = 0,
            y = 280,
            width = 70,
            height = 80,
        },
    },
}
-- Carregando a folha de imagens --
local inimigoSheet = graphics.newImageSheet( "images/fase01/inimigos/inimigosFase01.png", inimigoSheetOptions )
--------------------------------------------------------------------------------------
local disparoSheetOptions = 
{
    frames = {

        { -- verde
            x = 0,
            y = 0,
            width = 50,
            height = 80,
        },
        { -- laranja
            x = 50,
            y = 0,
            width = 50,
            height = 80,
        },
        {
            -- roxo
            x = 0,
            y = 80,
            width = 50,
            height = 80,
        },
        {
            -- chefe
            x = 50,
            y = 80,
            width = 60,
            height = 90,
        },
    },
}
local disparoSheet = graphics.newImageSheet("images/fase01/inimigos/inimigosFase1Disparos.png", disparoSheetOptions)

---------------------------------------------------------------------------------------

function spriteInimigo.carregarInimigo(grupo,tipo)
  
    if( tipo ~= 1 ) then
        return display.newImageRect( grupo, inimigoSheet, tipo, 50, 60 )
    else
        return display.newImageRect( grupo, inimigoSheet, tipo, 70, 90)
    end
    
end

function spriteInimigo.carregarTiro(grupo, tipo)

    if( tipo ~= 1 ) then
        return display.newImageRect( grupo, disparoSheet, tipo-1, 100, 200 )
    else
        return display.newImageRect( grupo, disparoSheet, 4, 60, 80 )
    end
end

return spriteInimigo