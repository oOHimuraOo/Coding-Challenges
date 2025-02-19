class_name CANVAS
extends Node2D

var grid: GRID
var colunas:int = 64
var linhas:int = 36
var mouse_x:int
var mouse_y:int
var liberar_multiplos = false

func _ready():
	gerar_grid() 

func gerar_grid() -> void:
	grid = GRID.new(colunas, linhas, get_viewport().size)
	add_child(grid)

func _process(delta):
	mouse_x = floor(get_global_mouse_position().x / (get_viewport().size.x / colunas))
	mouse_y = floor(get_global_mouse_position().y / (get_viewport().size.y / linhas))
	grid.no_process(mouse_x, mouse_y)
	
	if Input.is_action_just_pressed("ui_accept"):
		liberar_multiplos = !liberar_multiplos
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		grid.calcular_movimento(grid.grid1[mouse_x][mouse_y])
		if liberar_multiplos:
			grid.calcular_movimento(grid.grid1[mouse_x][mouse_y].up)
			grid.calcular_movimento(grid.grid1[mouse_x][mouse_y].down)
			grid.calcular_movimento(grid.grid1[mouse_x][mouse_y].left)
			grid.calcular_movimento(grid.grid1[mouse_x][mouse_y].right)
