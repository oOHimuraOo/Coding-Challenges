class_name PARTICULA
extends Node2D

var posicao:Vector2
var raio:float
var cor:Color

func _init(Angulo:float, RaioTela:float, RaioCirculo:float = 2, corCirculo:Color = 'ffffff') -> void:
	posicao = Vector2.from_angle(Angulo)
	posicao = _escalonar_vetor(RaioTela)
	raio = RaioCirculo
	cor = corCirculo
	add_to_group('particula')

func _escalonar_vetor(valor:float) -> Vector2:
	var novo_eixo_X = posicao.x * valor
	var novo_eixo_Y = posicao.y * valor
	var retorno:Vector2 = Vector2(novo_eixo_X,novo_eixo_Y)
	return retorno

func atualizar() -> void:
	self.posicao.x -= 1
	self.posicao.y -= randf_range(-3,3)
	
	var angulo = posicao.angle()
	angulo = _limitar_angulo(angulo, 0, PI/6)
	var magnitude = posicao.length()
	self.posicao = Vector2.RIGHT.rotated(angulo).normalized() * magnitude

func _draw():
	draw_circle(posicao, raio, cor)

func _limitar_angulo(angulo:float, limite_inicial:float, limite_final:float) -> float:
	var ang:float = angulo
	if ang < limite_inicial:
		ang = limite_inicial
	if ang > limite_final:
		ang = limite_final
	return ang

func intersepta(flocosDeNeve:Array) -> bool:
	var retorno:bool = false
	for floco:PARTICULA in flocosDeNeve:
		var distancia:float = self.posicao.distance_to(floco.posicao)
		if distancia < raio*2:
			retorno = true
			break
	return retorno

func terminado() -> bool:
	if self.posicao.x < 1:
		return true
	return false
