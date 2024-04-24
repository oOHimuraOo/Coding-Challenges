class_name DESENHO
extends Control

var estrelas:Array = []
var velocidade:float = 50

var tamanhoDaTela:Vector2 = Vector2(1920,1080)

func _ready():
	iniciar_tamanho_da_tela()
	for i in range(max(tamanhoDaTela.x,tamanhoDaTela.y)):
		estrelas.append(ESTRELA.new(tamanhoDaTela))

func iniciar_tamanho_da_tela() -> void:
	get_viewport().size = tamanhoDaTela
	pivot_offset = tamanhoDaTela/2
	print(pivot_offset)

func _process(_delta):
	queue_redraw()

func _input(_event) -> void:
	if Input.is_action_pressed('ui_up'):
		velocidade += 0.5
		if velocidade > 400:
			velocidade = 400
	elif Input.is_action_pressed('ui_down'):
		velocidade -= 0.5
		if velocidade < 1:
			velocidade = 0.5

func _draw():
	draw_rect(Rect2(-tamanhoDaTela/2,tamanhoDaTela),'000000')
	print(velocidade)
	for e in estrelas:
		e.atualizar(velocidade)
		e.revelar()
		draw_circle(Vector2(e.sx,e.sy), e.r, 'ffffff')

