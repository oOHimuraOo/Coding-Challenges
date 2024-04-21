class_name PAREDE
extends Node2D

var a:Vector2
var b:Vector2

func _init(x1:float,y1:float,x2:float,y2:float) -> void:
	self.a = Vector2(x1,y1)
	self.b = Vector2(x2,y2)

func revelar(nodo_pai:DESENHO, largura:float = 5.0) -> void:
	var linha = Line2D.new()
	linha.add_point(a)
	linha.add_point(b)
	linha.width = largura
	nodo_pai.add_child(linha)
