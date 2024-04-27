class_name HANKIN
extends Line2D

var A:Vector2
var B:Vector2
var C:Vector2

var fim:Vector2

var distanciaAnterior:float

var largura:float
var cor:Color

func _init(i:Vector2,j:Vector2, l:float = 1, c:Color = Color('ffffff')) -> void:
	self.A = i
	self.B = j
	self.C = A + B
	self.largura = l
	self.cor = c

func revelar(nodoPai:Node2D) -> void:
	self.width = largura
	self.default_color = cor
	self.add_point(A)
	self.add_point(fim)
	nodoPai.add_child(self)
	
func encontrarFim(outro:HANKIN) -> void:
	var denominador = (outro.B.y * self.B.x) - (outro.B.x * self.B.y)
	if !denominador:
		return
	var numerador_1 = (outro.B.x * (self.A.y - outro.A.y)) - (outro.B.y * (self.A.x - outro.A.x));
	var numerador_2 = (self.B.x * (self.A.y - outro.A.y)) - (self.B.y * (self.A.x - outro.A.x));
	var ua = numerador_1 / denominador;
	var ub = numerador_2 / denominador;
	var x = self.A.x + (ua * self.B.x);
	var y = self.A.y + (ua * self.B.y);
	if ua > 0 && ub > 0:
		var candidato:Vector2 = Vector2(x,y)
		var distancia_1:float = candidato.distance_to(self.A)
		var distancia_2:float = candidato.distance_to(outro.A)
		var distancia:float = distancia_1 + distancia_2
		var diferenca:float = abs(distancia_1 - distancia_2)
		if diferenca < 0.001:
			if !self.fim:
				self.fim = candidato
				self.distanciaAnterior = distancia
			elif distancia < self.distanciaAnterior:
				self.distanciaAnterior = distancia
				self.fim = candidato
