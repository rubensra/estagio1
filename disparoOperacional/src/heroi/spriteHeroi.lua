local spriteHeroi = {}
local nave

-- Folha de sprites das naves e seus tiros --
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
local naveSheet = graphics.newImageSheet( "images/herois/herois.png", naveSheetOptions )

function spriteHeroi.carregarHeroi(grupo,tipo)
  
    return display.newImageRect( grupo, naveSheet, tipo, 70, 80 )
end

function spriteHeroi.carregarTiro(grupo, tipo)
   
    return display.newImageRect( grupo, naveSheet, tipo+3, 15, 80 )
end

function spriteHeroi.carregarVida(grupo,tipo)
    return display.newImageRect( grupo, naveSheet, tipo, 70, 80 )
    
end


return spriteHeroi