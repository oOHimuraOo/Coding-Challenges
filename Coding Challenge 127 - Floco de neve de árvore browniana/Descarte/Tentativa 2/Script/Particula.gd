class_name PARTICULA_OLD
extends TextureRect

@onready var area:Area2D = $area
@onready var forma:CollisionShape2D = $area/forma

var pos:Vector2
var r:float

func iniciar_valores(raioTela:float, angulo:float,raioParticula:float) -> void:
	pos = Vector2.from_angle(angulo)
	pos = multiplicar_vetor(raioTela)
	r = raioParticula
	self.position = pos

func multiplicar_vetor(valor:float) -> Vector2:
	var novo_eixo_x:float = pos.x * valor
	var novo_eixo_y:float = pos.y * valor
	var retorno:Vector2 = Vector2(novo_eixo_x,novo_eixo_y)
	return retorno
	
func atualizar() -> void:
	self.pos.x -= 1
	self.pos.y += randf_range(-3,3)
	
	var angulo:float = pos.angle()
	angulo = limitar_angulo(angulo)
	var magnitude:float = pos.length()
	self.pos = Vector2.RIGHT.rotated(angulo).normalized() * magnitude
	self.position = pos

func limitar_angulo(ang:float) -> float:
	var retorno:float = ang
	if ang < 0:
		retorno = 0
	if ang > PI/6:
		retorno = PI/6
	return retorno

func revelar() -> void:
	if !self.is_visible_in_tree():
		self.show()

func intersepta(flocosDeNeve:Array) -> bool:
	var resultado:bool = false
	for floco:PARTICULA in flocosDeNeve:
		var distancia:float = self.pos.distance_to(floco.pos)
		if distancia < self.r*2:
			resultado = true
			break
	return resultado

func terminado() -> bool:
	if self.pos.x < 1:
		return true
	return false
