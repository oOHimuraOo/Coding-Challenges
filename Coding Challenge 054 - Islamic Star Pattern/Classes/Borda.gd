class_name BORDA
extends Line2D

var A:Vector2
var B:Vector2

var hankin_1:HANKIN
var hankin_2:HANKIN

var largura:float
var cor:Color

func _init(a:Vector2,b:Vector2, l:float = 2, c:Color = Color('ffff00')) -> void:
	self.A = a
	self.B = b
	self.largura = l
	self.cor = c

func revelar(nodoPai:Node2D) -> void:
	self.width = largura
	self.default_color = cor
	self.add_point(A)
	self.add_point(B)
	nodoPai.add_child(self)

func criar_hankin(angulo:float, delta:float) -> void:
	var centro:Vector2 = self.A + self.B
	centro = centro * 0.5
	
	var v1:Vector2 = A - centro
	var v2:Vector2 = B - centro
	var desvio_1:Vector2 = centro
	var desvio_2:Vector2 = centro
	if delta > 0:
		v1 = v1 * delta
		v2 = v2 * delta
		desvio_1 = centro + v2
		desvio_2 = centro + v1
	v1 = v1.rotated(deg_to_rad(-angulo)).normalized()
	v2 = v2.rotated(deg_to_rad(angulo)).normalized()
	
	self.hankin_1 = HANKIN.new(desvio_1, v1)
	self.hankin_2 = HANKIN.new(desvio_2, v2)

func encontrarFim(outro:BORDA) -> void:
	self.hankin_1.encontrarFim(outro.hankin_1)
	self.hankin_1.encontrarFim(outro.hankin_2)
	self.hankin_2.encontrarFim(outro.hankin_1)
	self.hankin_2.encontrarFim(outro.hankin_2)
