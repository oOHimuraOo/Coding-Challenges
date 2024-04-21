class_name PARTICULA
extends Node2D

var posicao:Vector2
var raios:Array
var linha:Line2D

func _init(x:float = 300, y:float = 300) -> void:
	self.posicao = Vector2(x,y)
	for a in range(0,360,1):
		self.raios.append(RAIO.new(self.posicao, deg_to_rad(a)))
	

func atualizar(x:float, y:float) -> void:
	self.posicao = Vector2(x,y)
	linha.set_point_position(0,self.posicao)
	linha.set_point_position(1,self.posicao + Vector2(1,1))

func olhar(Paredes:Array,nodo_pai:DESENHO) -> void:
	for i in range(raios.size()):
		var raio = self.raios[i]
		var perto = null
		var memoria = INF
		for parede in Paredes:
			var pt = raio.iluminar(parede)
			if pt:
				var d = self.posicao.distance_to(pt)
				if d < memoria:
					memoria = d
					perto = pt
		if perto:
			raio.linha.set_point_position(0,raio.posicao)
			raio.linha.set_point_position(1,perto)
		else:
			raio.linha.set_point_position(0,raio.posicao)
			raio.linha.set_point_position(1,raio.posicao+raio.direcao)
	for raio in raios:
		raio.posicao = self.posicao
		

func revelar(nodoPai:DESENHO, Largura:float = 10.0) -> void:
	linha = Line2D.new()
	linha.add_point(self.posicao)
	linha.add_point(self.posicao + Vector2(1,1))
	linha.width = Largura
	linha.name = 'particula'
	nodoPai.add_child(linha)
