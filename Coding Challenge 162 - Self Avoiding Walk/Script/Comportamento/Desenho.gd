class_name DESENHO
extends Node2D

@onready var camera_2d = $Camera2D

var grid:Array
var espaco:float = 50
var colunas:float
var linhas:float
var caminho:Array = []
var local:LOCALIDADE
var tamanhoTela:Vector2
var linha:Line2D

func _ready() -> void:
	tamanhoTela = Vector2(350,350)#get_viewport().size
	colunas = round(tamanhoTela.x / espaco) 
	linhas = round(tamanhoTela.y / espaco)
	grid = criar_array_bidimensional(colunas, linhas)
	for x in range(colunas):
		for y in range(linhas):
			grid[x][y] = LOCALIDADE.new(x,y,espaco)
	
	local = grid[colunas/2][linhas/2]
	caminho.append(local)
	local.visitado = true
	linha = Line2D.new()
	linha.width = 0.5
	add_child(linha)
	camera_2d.zoom = Vector2(50,50)

func _process(_delta) -> void:
	desenhar()

func _input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		camera_2d.zoom += Vector2(10,10)
		print(camera_2d.zoom)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		camera_2d.zoom -= Vector2(10,10)
		if camera_2d.zoom < Vector2(0.2,0.2):
			camera_2d.zoom = Vector2(0.1,0.1)
	elif Input.is_action_just_pressed("ui_down"):
		camera_2d.position.y += 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed('ui_up'):
		camera_2d.position.y -= 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed('ui_left'):
		camera_2d.position.x -= 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed('ui_right'):
		camera_2d.position.x += 10
		print(camera_2d.position)
	elif Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
		

func desenhar() -> void:
	local = local.proximo_local(self)
	if !local:
		var travado:LOCALIDADE = caminho.pop_back()
		travado.limpar()
		local = caminho[caminho.size() - 1]
	else:
		caminho.append(local)
		local.visitado = true
	
	if caminho.size() == colunas * linhas:
		print('Resolvido!')
		set_process(false)

	var path_vertices = []
	for loc:LOCALIDADE in caminho:
		path_vertices.append(Vector2(loc.posicao.x, loc.posicao.y))

	linha.points = path_vertices

func criar_array_bidimensional(col:float,lin:float) -> Array:
	var arrayDeColunas:Array = []
	for x in range(col):
		var arrayDeLinhas:Array = []
		for y in range(lin):
			arrayDeLinhas.append(null)
		arrayDeColunas.append(arrayDeLinhas)
	return arrayDeColunas
		
