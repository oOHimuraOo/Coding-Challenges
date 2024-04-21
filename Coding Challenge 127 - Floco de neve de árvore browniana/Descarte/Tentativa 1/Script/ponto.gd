class_name PONTO_OLD
extends TextureRect

var x:float
var y:float

func iniciar_valores(X:float, Y:float) -> void:
	x = X
	y = Y/2
	self.global_position = Vector2(x,y)

func movimento() -> void:
	x -= 1
	y += randi_range(-1,1)
	self.position = Vector2(x,y)

func movimentoTerminado(vector:Vector2) -> bool:
	var limite_x = vector.x/2
	if self.x < limite_x:
		return true
	return false

func sobrepoe(arrayDeParticulas:Array) -> bool:
	for ponto:PONTO in arrayDeParticulas:
		var posicaoAtualA:Vector2 = self.position
		var posicaoAtualB:Vector2 = ponto.position
		var distancia = posicaoAtualA.distance_to(posicaoAtualB)
		if distancia < 10:
			return true
	return false
		
