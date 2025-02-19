@tool
class_name GRID
extends Node2D

@export_range(1,255) var linhas:int = 10
@export_range(1,255) var colunas:int = 10
@export var tamanho_tela:Vector2i = Vector2i(1440,900)

var ajustar_tela:bool = false
var grid1: Array
var mouse_x_antigo:int
var mouse_y_antigo:int
var cell_size: Vector2
var timer:Timer = Timer.new()
var timer2:Timer = Timer.new()
var timer3:Timer = Timer.new()
var h:float = 0.47
var s:float = 0.25
var v:float = 0.33

func _init(col:int, lin:int, tamTel:Vector2i = Vector2i(1440,900)) -> void:
	linhas = lin
	colunas = col
	
	if tamanho_tela != tamTel:
		tamanho_tela = tamTel
		ajustar_tela = true

func _ready():
	if ajustar_tela:
		ajustar_viewport()

	main_grid()
	gerar_timers()

func gerar_timers() -> void:
	timer.autostart = true
	timer2.autostart = true
	timer3.autostart = true
	timer.wait_time = 1
	timer2.wait_time = 1.5
	timer3.wait_time = 2.0
	timer.one_shot = false
	timer2.one_shot = false
	timer3.one_shot = false
	add_child(timer)
	add_child(timer2)
	add_child(timer3)
	timer.timeout.connect(on_timer_timeout)
	timer2.timeout.connect(on_timer2_timeout)
	timer3.timeout.connect(on_timer3_timeout)

func on_timer_timeout() -> void:
	h += 0.05
	if h >= 1.0:
		h = 0.47

func on_timer2_timeout() -> void:
	s += 0.05
	if s >= 1.0:
		s = 0.25

func on_timer3_timeout() -> void:
	v += 0.05
	if v >= 1.0:
		v = 0.33

func ajustar_viewport() -> void:
	get_viewport().size = tamanho_tela

func main_grid() -> void:
	cell_size.x = tamanho_tela.x / colunas
	cell_size.y = tamanho_tela.y / linhas
	
	var array_colunas = []
	
	for x in range(colunas):
		var array_linhas = []
		for y in range(linhas):
			var grain: GRAIN = GRAIN.new(cell_size,Vector2(cell_size.x * x, cell_size.y * y))
			array_linhas.append(grain)
		array_colunas.append(array_linhas)
	
	grid1 = array_colunas
	
	for x in grid1.size():
		for y in grid1[x].size():
			var grain: GRAIN = grid1[x][y]
			var cima: GRAIN 
			var baixo: GRAIN
			var esquerda: GRAIN
			var direita: GRAIN
			if y == 0:
				cima = null
			else:
				cima = grid1[x][y-1]
			
			if y == grid1[x].size() - 1:
				baixo = null
			else:
				baixo = grid1[x][y+1]
			
			if x == 0 && x < grid1.size():
				esquerda = null
			else:
				esquerda = grid1[x-1][y]
			
			if x == grid1.size() - 1:
				direita = null
			else:
				direita = grid1[x+1][y]
			
			grain.criar_links(cima, baixo, esquerda, direita)
	instanciar_grid()

func no_process(mouse_x:int, mouse_y:int) -> void:
	if mouse_x > grid1.size() - 1 || mouse_y < 0:
		return
	if mouse_y > grid1[0].size() - 1 || mouse_y < 0:
		return
	
	for x in grid1.size():
		for y in grid1[x].size():
			if x == mouse_x && y == mouse_y:
				grid1[x][y].mouse_show(true)
			else:
				grid1[x][y].mouse_show(false)
	

func calcular_movimento(grain:GRAIN) -> void:
	if grain == null:
		return
	if grain.down == null: 
		return
	
	var next_grain:GRAIN = descobrir_proxima_direcao(grain.down)
	
	if next_grain == null:
		return
	
	next_grain.h = h
	next_grain.s = s
	next_grain.v = v
	next_grain.redefinir_cor()
	next_grain.redraw(true)
	grain.redraw(false)
	
	await get_tree().create_timer(0.01).timeout
	calcular_movimento(next_grain)

func descobrir_proxima_direcao(grain:GRAIN) -> GRAIN:
	if grain.active:
		if grain.rand == 0:
			if grain.right == null:
				return
			if grain.right.active:
				if grain.left == null:
					return
				if grain.left.active:
					return
				return grain.left
			return grain.right
		else:
			if grain.left == null:
				return
			if grain.left.active:
				if grain.right == null:
					return
				if grain.right.active:
					return
				return grain.right
			return grain.left
	else:
		return grain
	
func instanciar_grid() -> void:
	for x in grid1.size():
		for y in grid1[x].size():
			var grain:GRAIN = grid1[x][y]
			add_child(grain)
