class_name DESENHO
extends Node2D

var componente_inicial:float = 100
var fator_de_multiplicacao:float = 4
var modificador_de_tamanho_de_circulos_subsequentes:float = 2.0 #o valor tem que ser >= 0
var quantidade_de_circulos:int = 10
var velocidade_de_rotacao:float = 0.016
var tamanho_do_offset:float = 300

var tempo:float = 0.0
var caminho:Array = []
var onda:Array = []

var tamanhoTela:Vector2 = Vector2(1920,1080)
var linha:Line2D
var cores:Array = []

func _ready():
	iniciar_tamanho_da_tela()
	iniciar_linha()
	
	for i in range(quantidade_de_circulos):
		var cor:Color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
		cores.append(cor)

func _input(_event):
	if Input.is_action_just_pressed('q'):
		componente_inicial += 1
	elif Input.is_action_just_pressed('a'):
		componente_inicial -= 1
	elif Input.is_action_just_pressed('w'):
		fator_de_multiplicacao += 0.1
	elif Input.is_action_just_pressed('s'):
		fator_de_multiplicacao -= 0.1
	elif Input.is_action_just_pressed('e'):
		modificador_de_tamanho_de_circulos_subsequentes += 0.1
	elif Input.is_action_just_pressed('d'):
		modificador_de_tamanho_de_circulos_subsequentes -= 0.1
	elif Input.is_action_just_pressed('r'):
		quantidade_de_circulos += 1
		for i in range(quantidade_de_circulos):
			if i >= cores.size():
				var cor:Color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
				cores.append(cor)
	elif Input.is_action_just_pressed('f'):
		quantidade_de_circulos -= 1
	elif Input.is_action_just_pressed('t'):
		velocidade_de_rotacao += 0.016
	elif Input.is_action_just_pressed('g'):
		velocidade_de_rotacao -= 0.016
	elif Input.is_action_just_pressed('y'): 
		tamanho_do_offset += 25
	elif Input.is_action_just_pressed('h'): 
		tamanho_do_offset -= 25


func iniciar_tamanho_da_tela() -> void:
	get_viewport().size = Vector2i(tamanhoTela)

func iniciar_linha() -> void:
	linha = Line2D.new()
	for i in range(tamanhoTela.x - tamanho_do_offset*2):
		linha.add_point(Vector2(i+tamanho_do_offset*2,tamanhoTela.y/2))
	linha.width = 1
	add_child(linha)

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela),Color('000000'))
	
	var x:float = 0.0
	var y:float = 0.0
	
	for i in range(quantidade_de_circulos):
		var x_antigo:float = x
		var y_antigo:float = y
		
		var numero_de_circulos:float = i * modificador_de_tamanho_de_circulos_subsequentes + 1
		var raio = componente_inicial * (fator_de_multiplicacao / (numero_de_circulos * PI))
		
		x += raio * cos(numero_de_circulos * tempo)
		y += raio * sin(numero_de_circulos * tempo)
		
		
		draw_circle(Vector2(x+tamanho_do_offset,y+(tamanhoTela.y/2)),4,'ff0000')
		draw_arc(Vector2(x_antigo+tamanho_do_offset,y_antigo+(tamanhoTela.y/2)),raio,0,359,360,cores[i],1)
	
	onda.push_front(y)
	
	draw_line(Vector2(x+tamanho_do_offset,y+(tamanhoTela.y/2)),Vector2(0+tamanho_do_offset*2,onda[0]+(tamanhoTela.y/2)),'ffff00',1)
	
	
	for i in range(onda.size()):
		if i < tamanhoTela.x - tamanho_do_offset*2:
			linha.set_point_position(i,Vector2(i+tamanho_do_offset*2,onda[i]+tamanhoTela.y/2))
		else:
			onda.pop_back()
	
	tempo += velocidade_de_rotacao

func _process(_delta):
	pass

func _physics_process(_delta):
	queue_redraw()
