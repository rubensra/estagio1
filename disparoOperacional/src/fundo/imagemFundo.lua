local fundo = {}

function fundo.Fase1(grupo)
    return display.newImageRect( grupo, "images/fase01/fundo/circuito00_320x480.png", 320, 480 )   
end

function fundo.Fase2(grupo)
    return display.newImage( grupo, "images/fase02/fundo/fase2_1061x1707.png", 320, 480 )
end

function fundo.Fase3(grupo)

    local imagens = {}
    imagens.um = display.newImage( grupo, "images/fase03/fundo/fase3.1_1280.png", 320, 480 );
    imagens.dois = display.newImage( grupo, "images/fase03/fundo/fase3.2_1280.png", 320, 480 );
    return imagens
end

function fundo.Fim(grupo)
    local imagem = display.newImageRect( grupo, "images/fase01/fundo/circuito00_320x480.png", 320, 480 );
    imagem.x = display.contentCenterX 
	imagem.y = display.contentCenterY
	imagem.xScale = 1.0 
	imagem.yScale = 1.0
    return imagem

end

return fundo