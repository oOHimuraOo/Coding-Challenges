class_name CURVA
extends Node2D

var caminho:Array = []
var atual:Vector2 = Vector2.ZERO
var curva:Line2D 
var ponto:PONTO

func _init(nodoPai:Node2D) -> void:
	iniciar_curva(nodoPai)
	iniciar_ponto(nodoPai)

func iniciar_curva(nodoPai:Node2D) -> void:
	curva = Line2D.new()
	curva.width = 1
	nodoPai.add_child(curva)

func iniciar_ponto(nodoPai:Node2D) -> void:
	ponto = PONTO.new(nodoPai, atual, 2, Color('#ff0000'))
	nodoPai.add_child(ponto)

func iniciar_eixo_x_e_eixo_y(eixoX:float, eixoY:float) -> void:
	self.atual.x = eixoX
	self.atual.y = eixoY

func adicionar_ponto() -> void:
	self.caminho.append(atual)
	atual = Vector2.ZERO

func resetar() -> void:
	self.caminho.clear()

func desenhar() -> void:
	curva.points = caminho
