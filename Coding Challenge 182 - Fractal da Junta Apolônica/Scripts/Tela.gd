extends Node2D

@onready var circulo:PackedScene = preload("res://Cenas/Circulo.tscn")
@onready var timer = $Timer
@onready var timer_2 = $Timer2

var todosCirculos:Array
var fila:Array
var count:int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	criar_circulos()
		
func gerar_novo_circulo() -> void:
	var novafila = []
	for tripla in fila:
		var c1 = tripla[0]
		var c2 = tripla[1]
		var c3 = tripla[2]
		var k4 = descartes(c1,c2,c3)
		var novosCirculos = descartesComplexo(c1,c2,c3,k4)
		
		for nc in novosCirculos:
			if validar(nc, c1, c2, c3):
				todosCirculos.append(nc)
				var t1 = [c1, c2, nc]
				var t2 = [c2, c3, nc]
				var t3 = [c1, c3, nc]
				novafila.append_array([t1,t2,t3]) 
				novo_circulo(nc)
	fila.append_array(novafila)

func validar(c4:CIRCULO, c1:CIRCULO, c2:CIRCULO, c3:CIRCULO) -> bool:
	if c4.raio < 5: return false
	
	for outro:CIRCULO in todosCirculos:
		var pos1 = c4.global_position
		var pos2 = outro.global_position
		var dist = abs(pos1.distance_to(pos2))
		var difRaio = abs(c4.raio - outro.raio)
		var eps = 0.1
		
		if dist < eps && difRaio < eps:
			return false
	
	if !ehTangente(c4,c1): return false
	if !ehTangente(c4,c2): return false
	if !ehTangente(c4,c3): return false
	
	return true

func ehTangente(c1:CIRCULO, c2:CIRCULO) -> bool:
	var r1 = c1.raio
	var r2 = c2.raio
	var pos1 = c1.global_position
	var pos2 = c2.global_position
	var dist = pos1.distance_to(pos2)
	var eps = 0.1
	
	var boleana1:bool = abs(dist - (r1 + r2)) < eps
	var boleana2:bool = abs(dist - abs(r2 - r1)) < eps
	
	if boleana1 || boleana2:
		return true
	else:
		return false

func criar_circulos() -> void:
	var viewportTamanho = get_viewport().size
	var x = viewportTamanho.x
	var y = viewportTamanho.y
	
	var circulo_instancia_1:CIRCULO = circulo.instantiate()
	circulo_instancia_1.iniciarValores(x/2,y/2,-1.0/(x/2))
	circulo_instancia_1.montarCirculo()
	todosCirculos += [circulo_instancia_1]
	
	var r2 = randf_range(circulo_instancia_1.centro.a/8, circulo_instancia_1.raio)
	var v = Vector2(cos(randf_range(0, TAU)), sin(randf_range(0, TAU)))
	v = set_mag(v, circulo_instancia_1.raio - r2)

	var circulo_instancia_2:CIRCULO = circulo.instantiate()
	circulo_instancia_2.iniciarValores(circulo_instancia_1.centro.a + v.x, circulo_instancia_1.centro.b + v.y, 1.0/r2)
	circulo_instancia_2.montarCirculo()
	todosCirculos += [circulo_instancia_2]
	
	
	var r3 = circulo_instancia_1.raio - circulo_instancia_2.raio
	v.rotated(PI)
	var v3 = set_mag(v, circulo_instancia_1.raio - r3)
	
	var circulo_instancia_3:CIRCULO = circulo.instantiate()
	circulo_instancia_3.iniciarValores(circulo_instancia_1.centro.a - v3.x, circulo_instancia_1.centro.b - v3.y, 1.0/r3)
	circulo_instancia_3.montarCirculo()
	todosCirculos += [circulo_instancia_3]
	
	for circ in todosCirculos:
		novo_circulo(circ)
	fila = [[circulo_instancia_1, circulo_instancia_2, circulo_instancia_3]]

func set_mag(vetor: Vector2, comprimento: float) -> Vector2:
	if vetor == Vector2.ZERO:
		return vetor 
	else:
		return vetor.normalized() * comprimento

func novo_circulo(circ:CIRCULO):
	circ.name = str(count)
	add_child(circ)
	count += 1

func descartes(circulo1:CIRCULO,circulo2:CIRCULO,circulo3:CIRCULO) -> Array:
	var curvatura1 = circulo1.curvatura
	var curvatura2 = circulo2.curvatura
	var curvatura3 = circulo3.curvatura
	
	var soma = curvatura1 + curvatura2 + curvatura3
	var produto = abs(curvatura1*curvatura2 + curvatura2*curvatura3 + curvatura1*curvatura3)
	var raiz = 2* sqrt(produto)
	
	var resultado = [soma + raiz, soma - raiz]
	return resultado

func descartesComplexo(circulo1:CIRCULO, circulo2:CIRCULO, circulo3:CIRCULO, curvaturaCirculo4:Array) -> Array:
	var curvatura1:float = circulo1.curvatura
	var curvatura2:float = circulo2.curvatura
	var curvatura3:float = circulo3.curvatura
	var centro1:COMPLEXOS = circulo1.centro
	var centro2:COMPLEXOS = circulo2.centro
	var centro3:COMPLEXOS = circulo3.centro
	
	var CurCen1:COMPLEXOS = centro1.scalonar(curvatura1)
	var CurCen2:COMPLEXOS = centro2.scalonar(curvatura2)
	var CurCen3:COMPLEXOS = centro3.scalonar(curvatura3)
	
	var soma:COMPLEXOS = CurCen1.somar(CurCen2).somar(CurCen3)
	var raiz:COMPLEXOS = CurCen1.multiplicar(CurCen2).somar(CurCen2.multiplicar(CurCen3)).somar(CurCen1.multiplicar(CurCen3))
	raiz = raiz.raizQuadrada().scalonar(2)
	
	var cen1 = soma.somar(raiz).scalonar(1.0/curvaturaCirculo4[0])
	var cen2 = soma.subtrair(raiz).scalonar(1.0/curvaturaCirculo4[0])
	var cen3 = soma.somar(raiz).scalonar(1.0/curvaturaCirculo4[1])
	var cen4 = soma.subtrair(raiz).scalonar(1.0/curvaturaCirculo4[1])
	
	var retorno = []
	
	var circulo_instancia_1:CIRCULO = circulo.instantiate()
	circulo_instancia_1.iniciarValores(cen1.a,cen1.b,curvaturaCirculo4[0])
	circulo_instancia_1.montarCirculo()
	retorno += [circulo_instancia_1]
	
	var circulo_instancia_2:CIRCULO = circulo.instantiate()
	circulo_instancia_2.iniciarValores(cen2.a,cen2.b,curvaturaCirculo4[0])
	circulo_instancia_2.montarCirculo()
	retorno += [circulo_instancia_2]
	
	var circulo_instancia_3:CIRCULO = circulo.instantiate()
	circulo_instancia_3.iniciarValores(cen3.a,cen3.b,curvaturaCirculo4[1])
	circulo_instancia_3.montarCirculo()
	retorno += [circulo_instancia_3]
	
	var circulo_instancia_4:CIRCULO = circulo.instantiate()
	circulo_instancia_4.iniciarValores(cen4.a,cen4.b,curvaturaCirculo4[1])
	circulo_instancia_4.montarCirculo()
	retorno += [circulo_instancia_4]
	
	return retorno

func _on_timer_timeout():
	var len1 = todosCirculos.size()
	
	gerar_novo_circulo()
	
	var len2 = todosCirculos.size()
	
	if len1 == len2:
		timer.stop()
		timer_2.start()


func reiniciar() -> void:
	if timer.is_stopped():
		var filhos = get_children()
		for filho in filhos:
			if filho != timer && filho != timer_2:
				todosCirculos.erase(filho)
				filho.queue_free()
	
	criar_circulos()
	timer.start()


func _on_timer_2_timeout():
	reiniciar()
