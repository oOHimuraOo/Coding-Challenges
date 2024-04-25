class_name TSP_MENU
extends Control

const lexigraphicOrder:PackedScene = preload("res://Cena/LexigraphicOrder.tscn")
const tspComGeneticAlgorthm:PackedScene = preload("res://Cena/TSPComGeneticAlgorithm.tscn")
const tspComLexigrafico:PackedScene = preload("res://Cena/TSPComLexigrafico.tscn")
const tspComConstructiveHeuristic:PackedScene = preload("res://Cena/TSPConstuctiveHeuristic.tscn")
const tspSimpls:PackedScene = preload("res://Cena/TSPSimples.tscn")

var tamanhoTela:Vector2i = Vector2i(1152,648)
var resolucao:Vector2i = Vector2i(2260,1200)

func _ready():
	iniciar_padronizacao_tela()

func iniciar_padronizacao_tela() -> void:
	var pos_offset:Vector2 = resolucao - tamanhoTela
	get_viewport().size = tamanhoTela
	get_window().position = Vector2(pos_offset.x/2,pos_offset.y/2)

func _on_texture_button_pressed():
	var lex_intancia = lexigraphicOrder.instantiate()
	add_child(lex_intancia)


func _on_texture_button_2_pressed():
	var tsps_inst = tspSimpls.instantiate()
	add_child(tsps_inst)


func _on_texture_button_3_pressed():
	var tsp_lex = tspComLexigrafico.instantiate()
	add_child(tsp_lex)


func _on_texture_button_4_pressed():
	var tsp_gen = tspComGeneticAlgorthm.instantiate()
	add_child(tsp_gen)


func _on_texture_button_5_pressed():
	var tsp_heu = tspComConstructiveHeuristic.instantiate()
	add_child(tsp_heu)


func _on_texture_button_6_pressed():
	get_tree().quit()
