class_name DESENHO
extends Control

@onready var celulaCena:PackedScene = preload("res://Cena/Celula.tscn")

var tamanhoDaTela:Vector2i = Vector2i(1920,1080)
var tamanhoDaCelula:float = 60

var celulas:Array = []

var celulaAtual:CELULA
var proximo

var colunas:float
var linhas:float

var pilha:Array = []

func _ready():
	iniciar_tamanho_da_tela()
	iniciar_celulas()
	celulaAtual = celulas.pick_random()

func iniciar_tamanho_da_tela() -> void:
	get_viewport().size = tamanhoDaTela

func iniciar_celulas() -> void:
	colunas = tamanhoDaTela.x / tamanhoDaCelula
	linhas = tamanhoDaTela.y / tamanhoDaCelula
	for y in range(linhas):
		for x in range(colunas):
			instanciar_celula(x,y)

func instanciar_celula(eixoX:float,eixoY:float) ->void:
	var celula:CELULA = celulaCena.instantiate()
	celula.p = Vector2(eixoX,eixoY) * tamanhoDaCelula/2
	celula.t = tamanhoDaCelula
	celula.l = 1
	celula.idX = eixoX
	celula.idY = eixoY
	add_child(celula)
	celulas.append(celula)

func _process(_delta):
	celulaAtual.visitado = true
	celulaAtual.atual = true

func _on_timer_timeout():
	proximo = celulaAtual.verificar_visinho(celulas,colunas,linhas)
	if proximo != null:
		celulaAtual.atual = false
		pilha.append(celulaAtual)
		remover_paredes(celulaAtual,proximo)
		celulaAtual = proximo
	elif pilha.size() > 0:
		var celula:CELULA = pilha.pop_back()
		celulaAtual = celula

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func remover_paredes(celula_a:CELULA, celula_b:CELULA) -> void:
	var x = celula_a.idX - celula_b.idX
	if x == 1:
		celula_a.paredesAtivas[3] = false
		celula_b.paredesAtivas[1] = false
	elif x == -1:
		celula_a.paredesAtivas[1] = false
		celula_b.paredesAtivas[3] = false
	
	var y = celula_a.idY - celula_b.idY
	if y == 1:
		celula_a.paredesAtivas[0] = false
		celula_b.paredesAtivas[2] = false
	elif y == -1:
		celula_a.paredesAtivas[2] = false
		celula_b.paredesAtivas[0] = false
	
