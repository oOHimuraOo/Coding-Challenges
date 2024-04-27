extends Control

@onready var container_de_tiles:MarginContainer = $VBoxContainer/ContainerDeTiles
@onready var slider_angulo:HSlider = $VBoxContainer/Sliders/SliderAngulo
@onready var slider_delta:HSlider = $VBoxContainer/Sliders/SliderDelta
@onready var slider_incremento:HSlider = $VBoxContainer/Sliders/SliderIncremento

var poligonos:Array = []

var angulo:float = 75
var delta:float = 0.0
var incremento:float = 300

var largura:int
var altura:int
var tamanhoTela:Vector2i = Vector2i(1920,1080)
var resolucaoTela:Vector2i = Vector2i(2260,1200)

var numeroDeLados:int = 4

func _ready():
	iniciar_padronizacao_tela()
	angulo = slider_angulo.value
	delta = slider_delta.value
	incremento = slider_incremento.value
	largura = tamanhoTela.x / incremento
	altura = (tamanhoTela.y - 30) / incremento
	await get_tree().create_timer(0.1).timeout
	inicializar_tiles()

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucaoTela - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func _draw():
	draw_rect(Rect2(Vector2(0,0),tamanhoTela), '000000')

func inicializar_tiles() -> void:
	for x in range(largura):
		for y in range(altura):
			var poli:POLIGONO = POLIGONO.new()
			container_de_tiles.add_child(poli)
			var teste_x = poli.criarFormaGeometricaRegular(numeroDeLados,incremento, x * incremento + (x*incremento), y* incremento + (y*incremento))
			#var teste_y = poli.criarFormaGeometrica(numeroDeLados,y * incremento)
			var novosV:Array
			for i in range(numeroDeLados):
				var novoX = teste_x[i].x
				#var novoY = teste_y[i].y
				#novosV.append(Vector2(novoX,novoY))
			poli.adicionar_vertice_regular(teste_x)
			poli.fechar()
			poli.criar_hankin(angulo,delta)
			poligonos.append(poli)

func limpar_tiles() -> void:
	for poli:POLIGONO in poligonos:
		poli.queue_free()
	poligonos.clear()

func _on_slider_angulo_value_changed(value):
	angulo = value
	limpar_tiles()
	inicializar_tiles()


func _on_slider_delta_value_changed(value):
	delta = value
	limpar_tiles()
	inicializar_tiles()


func _on_slider_incremento_value_changed(value):
	incremento = value
	largura = tamanhoTela.x / incremento
	altura = (tamanhoTela.y - 30) / incremento
	limpar_tiles()
	inicializar_tiles()
