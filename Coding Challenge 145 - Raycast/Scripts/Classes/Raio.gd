class_name RAIO
extends Node2D

var posicao:Vector2
var direcao:Vector2
var angulo:float
var linha:Line2D

func _init(pos:Vector2, ang:float) -> void:
	self.posicao = pos
	self.direcao = Vector2.from_angle(ang)
	

func olhar_para(x:float, y:float) -> void:
	self.direcao.x = x - self.posicao.x
	self.direcao.y = y - self.posicao.y
	self.direcao.normalized()

func revelar(nodo_pai:Node2D) -> void:
	var largura_da_linha:int = 1
	var final_da_linha:Vector2 = self.posicao + self.direcao
	linha = Line2D.new()
	linha.add_point(self.posicao)
	linha.add_point(final_da_linha)
	linha.width = largura_da_linha
	nodo_pai.add_child(linha)

func iluminar(parede:PAREDE) -> Vector2:
	var x1 = parede.a.x
	var y1 = parede.a.y
	var x2 = parede.b.x
	var y2 = parede.b.y
	
	var x3 = self.posicao.x
	var y3 = self.posicao.y
	var x4 = self.posicao.x + self.direcao.x
	var y4 = self.posicao.y + self.direcao.y
	
	var den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
	if den == 0:
		return Vector2.ZERO
	
	var t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
	var u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den
	if t > 0 && t < 1 && u > 0:
		var pt:Vector2
		pt.x = x1 + t * (x2 - x1)
		pt.y = y1 + t * (y2 - y1)
		return pt
	else:
		return Vector2.ZERO
