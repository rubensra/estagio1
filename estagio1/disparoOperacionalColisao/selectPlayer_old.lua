module(..., package.seeall);
 
local selected = "Janela";
local player;
 
function getSelected()
	return selected;
end
 
function isVisible()
	return player.isVisible;
end
 
local callbackFunction;
function callback(listener)
	callbackFunction = listener;
end
 
function configuraTela()
	player = display.newImageRect( "image/Selecao_Naves_"..selected..".png", display.contentWidth, display.contentHeight);
	player:translate(320,480);
	player:addEventListener("tap", selectPlayer);
end
 
function selectPlayer( event )
   if(selected == "Janela") then
	    player.isVisible = false; 
           elseif (event.y >= 156 and event.y <= 260) then--maca 
              selected = "maca"; 
           elseif (event.y >= 261 and event.y <= display.contentHeight) then--pinguim
              selected = "pinguim";  
           end 
   elseif (selected == "maca") then 
        player.isVisible = false; 
            elseif (event.y >= 1 and event.y <= 155) then--Janela 
                selected = "Janela"; 
        elseif (event.y >= 261 and event.y <= display.contentHeight) then--pinguim
            selected = "pinguim";  
        end 
   elseif (selected == "pinguim") then 
        player.isVisible = false; 
            elseif (event.y >= 1 and event.y <= 155) then--Janela 
        selected = "Janela"; 
        elseif (event.y >= 156 and event.y <= 260) then--maca
        selected = "pinguim";  
        end 
   end
 
   player:removeSelf();
   if(player.isVisible == true) then
	configuraTela();
   else 
      callbackFunction();
   end
end