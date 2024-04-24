class_name GALHO
extends Line2D

var i:Vector2
var f:Vector2
var terminado:bool = false

func _init(inicio:Vector2, final:Vector2, l):
	i = inicio
	f = final
	add_point(i)
	add_point(f)
	width = l
	default_color = '4b3621'

func revelar(nodoPai:Node2D) -> void:
	nodoPai.add_child(self)

func galhoA() -> GALHO:
	randomize()
	var direcao:Vector2 = f - i
	direcao = rotacionar_vetor(direcao, PI/randi_range(2,8))
	direcao = direcao * 0.67
	var novoFinal = f + direcao
	var novoGalho = GALHO.new(f,novoFinal, width * 0.67)
	return novoGalho

func galhoB() -> GALHO:
	randomize()
	var direcao:Vector2 = f - i
	direcao = rotacionar_vetor(direcao, -PI/randi_range(2,8))
	direcao = direcao * 0.67
	var novoFinal = f + direcao
	var novoGalho = GALHO.new(f,novoFinal, width * 0.67)
	return novoGalho

func galhoC() -> GALHO:
	randomize()
	var direcao:Vector2 = f - i
	direcao = rotacionar_vetor(direcao, PI*randi_range(2,8))
	direcao = direcao * 0.67
	var novoFinal = f + direcao
	var novoGalho = GALHO.new(f,novoFinal, width * 0.67)
	return novoGalho

func galhoD() -> GALHO:
	randomize()
	var direcao:Vector2 = f - i
	direcao = rotacionar_vetor(direcao, -PI*randi_range(2,8))
	direcao = direcao * 0.67
	var novoFinal = f + direcao
	var novoGalho = GALHO.new(f,novoFinal, width * 0.67)
	return novoGalho
	
func rotacionar_vetor(vetor:Vector2, angulo:float) -> Vector2:
	var x = vetor.x * cos(angulo) - vetor.y * sin(angulo)
	var y = vetor.x * sin(angulo) + vetor.y * cos(angulo)
	return Vector2(x, y)
