-- title:   Dungeon demo
-- author:  Pedro G. H. Andrade
-- desc:    A small demo of the 8-bit rpg game.
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 1.0
-- script:  lua


game = {
	-- Variaveis
	w = 240,
	h = 136,
	
	CheckCollision = function(x, y)
		local tile = mget((x)//8, (y)//8)
		local collision = false
		if
			tile == 16 or
			tile == 20 or
			tile == 21 or
			tile == 5 or
			tite == 22 or
			tile == 23 or
			tile == 9 or
			tile == 10
		then
			collision = true
		else
			collision = false
		end
		if tile == 6 or tile == 20 then
			player.ky = player.ky + 1
			if tile == 6 then
				mset((x)//8, (y)//8, 1)
			elseif tile == 20 then
				mset((x)//8, (y)//8, 21)
			end
		end
		if tile == 24 then
			mset((x)//8, (y)//8, 25)
			if (x)//8 == 9 and (y)//8 == 6 then
				mset(27, 4, 26)
				mset(28, 4, 27)
			elseif (x)//8 == 21 and (y)//8 == 2 then
				mset(17, 16, 26)
				mset(18, 16, 27)
			end
		end
		if tile == 22 and player.ky >= 1 or tile == 23 and player.ky >= 1 then
			player.ky = player.ky - 1
			if tile == 22 then
				mset((x)//8, (y)//8, 7)
				mset((x)//8+1, (y)//8, 8)
			elseif tile == 23 then
				mset((x)//8-1, (y)//8, 7)
				mset((x)//8, (y)//8, 8)
			end
		elseif tile == 22 and player.ky <= 0 or tile == 23 and player.ky <= 0 then
			print('The gate is closed...', 55, 70, 3)
		end
		return collision
	end
}

mapa = {
	x = 0,
	y = 0,
	move = function(self)
		if player.x >= 240 then
			self.x = self.x + 29
			player.x = 2 * 8
		end
		if player.x <= 0 then
			self.x = self.x - 29
			player.x = (29 - 2) * 8
		end
		if player.y >= 136 then
			self.y = self.y + 16
			player.y = 2 * 8
		end
		if player.y <= 0 then
			self.y = self.y - 16
			player.y = (16 - 2) * 8
		end
	end
}

-- Todos os solidos estao aqui
solids = {
	wall = 16,
	bau = 20
}

player = {	
	-- Variaveis
		x = game.w-230,-- Posicao x do personagem
		y = game.h-113,-- Posicao y do personagem
		t = 0,-- Animacao
		sprs = 256,-- Sprite inicial
		fr = 4,-- Frames
		px = 1,-- Pixels
		h = 1,-- Altura
		w = 1,-- Largura
		invs = 0,-- Cor invisivel
		re = 0,-- Refletido
		pro = 1,-- Proporcao
		vxp = 1,-- vel. x positivo
		vxn = 1,-- vel. x negativo
		vyp = 1,-- vel. y positivo
		vyn = 1,-- vel. y negativo
		ky = 0,-- Numero de chaves
	
	-- Desenha o personagem
		draw = function()
			spr(player.t%(30*player.fr)//30*player.px+player.sprs,
							player.x,player.y,
							player.invs,player.pro,player.re,0,player.w,player.h)
		end,
		
		collision = function(solid)
			local check = game.CheckCollision
			
			-- Colisao do lado de cima
			if check(player.x, player.y) == solid
			 and check(player.x+8, player.y) == solid
				or check(player.x, player.y) == solid
			 and check(player.x, player.y+8) ~= solid
				or check(player.x+8, player.y) == solid
			 and check(player.x+8, player.y+8) ~= solid
			then
				player.vyn = 0
			else
				player.vyn = 1
			end

			-- Colisao do lado da direita
			if check(player.x+8, player.y) == solid
			 and check(player.x+8, player.y+8) == solid
				or check(player.x+8, player.y) == solid
			 and check(player.x, player.y) ~= solid
				or check(player.x+8, player.y+8) == solid
			 and check(player.x, player.y+8) ~= solid
			then
				player.vxp = 0
			else
				player.vxp = 1
			end

			-- Colisao do lado de baixo
			if check(player.x, player.y+8) == solid
			 and check(player.x+8, player.y+8) == solid
				or check(player.x, player.y+8) == solid
			 and check(player.x, player.y) ~= solid
				or check(player.x+8, player.y+8) == solid
			 and check(player.x+8, player.y) ~= solid
			then
				player.vyp = 0
			else
				player.vyp = 1
			end

			-- Colisao do lado da esquerda
			if check(player.x, player.y) == solid
			 and check(player.x, player.y+8) == solid
				or check(player.x, player.y) == solid
			 and check(player.x+8, player.y) ~= solid
				or check(player.x, player.y+8) == solid
			 and check(player.x+8, player.y+8) ~= solid
			then
				player.vxn = 0
			else
				player.vxn = 1
			end
		end,

	-- Move o personagem
		move = function(input)
			if input == true then
				if btn(0) then
				 player.y = player.y - player.vyn
				end
				
				if btn(1) then
				 player.y = player.y + player.vyp
				end
				
				if btn(2)	then
				 player.x = player.x - player.vxn
					player.re = 0
				end
				
				if btn(3)	then
				 player.x = player.x + player.vxp
					player.re = 1
				end
			end
		end
}
tic = 0
menu = true
function TIC()
	cls(0)
	if menu == true then
		map(60, 0)
		print('Dungeon demo', 51, 28, 7, false, 2, false)
		print('Press Z to play', 80, 78, 7, false, 1, false)
		if btn(4) then
			menu = false
		end
	else
		map(mapa.x, mapa.y)
		player.collision(true)
		
		if player.y >= 136 then
			mapa.x = 30
			mapa.y = 0
			print('Your time:', 163, 30, 12)
			print(tic//60, 185, 40, 12)
			print('Press X', 25, 92, 12)
			print('to back', 25, 102, 12)
			if btn(5) then
				reset()
			end
		else
			mapa:move()
			print('Time: '..tic//60 ..'s', 50, 0, 7)
			print('Keys: '..player.ky, 0, 0, 7)
			player.draw()
			player.move(true)
			player.t = player.t +1
			tic = tic + 1
		end
	end
end
