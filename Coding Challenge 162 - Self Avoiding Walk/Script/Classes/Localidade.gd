class_name LOCALIDADE
extends Node2D

var posicao:Vector2
var posicaoReal:Vector2
var opcoes:Array
var visitado:bool

func _init(x:float, y:float, desvio:float) -> void:
	self.posicao.x = x
	self.posicao.y = y
	self.posicaoReal.x = x * desvio
	self.posicaoReal.y = y * desvio
	self.opcoes = todas_as_opcoes()
	self.visitado = false

func todas_as_opcoes() -> Array:
	var arrayDeOpcoes:Array = [PASSO.new(1,0), PASSO.new(-1,0), PASSO.new(0,1), PASSO.new(0,-1)]
	return arrayDeOpcoes

func limpar() -> void:
	self.visitado = false
	self.opcoes = todas_as_opcoes()

func proximo_local(nodoPai:Node2D):
	var opcoesValidas:Array = []
	for opcao:PASSO in self.opcoes:
		var novoX = self.posicao.x + opcao.posicao.x
		var novoY = self.posicao.y + opcao.posicao.y
		if esta_valido(novoX,novoY,nodoPai) && !opcao.tentou:
			opcoesValidas.append(opcao)
	if opcoesValidas.size() > 0:
		var passo:PASSO = opcoesValidas.pick_random()
		passo.tentou = true
		return nodoPai.grid[self.posicao.x + passo.posicao.x][self.posicao.y + passo.posicao.y]
	return null

func esta_valido(x:float,y:float,nodoPai:Node2D) -> bool:
	if x < 0 || x >= nodoPai.colunas || y < 0 || y >= nodoPai.linhas:
		return false;
	return !nodoPai.grid[x][y].visitado;
