class_name DINO
extends CharacterBody2D

@onready var animacao:AnimatedSprite2D = $Animacao
@onready var colisao:CollisionShape2D = $Colisao
@onready var area_de_percepcao:Area2D = $AreaDePercepcao
@onready var colisao_da_area:CollisionShape2D = $AreaDePercepcao/ColisaoDaArea

var pos:Vector2 = Vector2(8912.1293,0819273.182)
var vel:Vector2 = Vector2(8912.1293,0819273.182)
var ace:Vector2 = Vector2.ZERO

var mensagem:String = "Posicao inicial, velocidade inicial ou tamanho da tela não definidos."

var maxVel:float = 50.0
var maxFor:float = 0.2
var tamTel:Vector2 = Vector2(8912.1293,0819273.182)

var mouseDentro:bool = false

##função responsavel por verificar se o dino foi inicializado corretamente ou não.
func _ready():
	assert(pos != Vector2(8912.1293,0819273.182) && vel != Vector2(8912.1293,0819273.182 && tamTel != Vector2(8912.1293,0819273.182)), mensagem)
	randomize()
	ativar_posicao_inicial(pos)

##função responsavel pela inicialização da posicao inicial do dino.
func ativar_posicao_inicial(posicaoInicial:Vector2) -> void:
	self.position = posicaoInicial

##função responsavel pela movimentação em contexto geral.
func ativar_movimentacao(velocidade:Vector2, dinos:Array) -> void:
	self.velocity = velocidade
	move_and_slide()
	if mouseDentro:
		self.vel = ace
		self.ace = ace.limit_length(maxVel)
	else:
		if is_on_wall():
			if ace.x > 0:
				self.ace.x = (ace.x + 600) * -1
			else:
				self.ace.x = (ace.x + 600)
		elif is_on_ceiling():
			self.ace.y = (ace.y + 600)
		elif is_on_floor():
			self.vel.y = (vel.y + 600) * -1
		else:
			var distancia:float = self.position.distance_to(dinos[randi_range(0,dinos.size() -1)].position)
			if distancia > self.colisao_da_area.shape.radius * 2:
				self.vel = dinos[0].position.normalized() * maxVel
			else:
				self.vel = Vector2.ZERO
			self.ace = ace.limit_length(maxVel)

##funções responsaveis por afastar o dino do mouse.
func _quando_mouse_entrar_na_area_de_percepcao():
	var direcaoAlvo:Vector2
	var posicaoMouse:Vector2 = get_global_mouse_position()
	var posicaoAtual:Vector2 = global_position
	direcaoAlvo = posicaoAtual - posicaoMouse
	vel = direcaoAlvo * (maxVel/3)
	mouseDentro = true

func _quando_mouse_sair_da_area_de_percepcao():
	vel = Vector2.ZERO
	mouseDentro = false

##função responsavel pelo comportamento do dino ao passar pela borda
func bordas() -> void:
	if self.position.x < 0:
		self.position.x = tamTel.x
	elif self.position.x > tamTel.x:
		self.position.x = 0
	
	if self.position.y < 0:
		self.position.y = tamTel.y
	elif self.position.y > tamTel.y:
		self.position.y = 0
		
	self.pos = position

##função responsavel por retornar um vetor que alinha o posicionamento de todos os nodos vizinhos.
func alinhar(dinos:Array) -> Vector2:
	var raioDePercepcao:float = colisao_da_area.shape.radius / 2
	var direcionar:Vector2 = Vector2.ZERO
	var total:int = 0
	for dino:DINO in dinos:
		var distancia:float = self.pos.distance_to(dino.pos)
		if dino != self && distancia < raioDePercepcao:
			direcionar += dino.vel
			total += 1
	if total > 0: 
		direcionar = direcionar/total
		direcionar = direcionar.normalized() * maxVel
		direcionar = direcionar - self.vel
		direcionar = direcionar.limit_length(maxFor)
	return direcionar.normalized()

##função responsavel por retornar um vetor que separa os dinos em uma direção oposta a que os visinhos estão
func separar(dinos:Array) -> Vector2:
	var raioDePercepcao:float = colisao_da_area.shape.radius /3
	var direcionar:Vector2 = Vector2.ZERO
	var total:int = 0
	for dino:DINO in dinos:
		var distancia:float = self.pos.distance_to(dino.pos)
		if dino != self && distancia < raioDePercepcao:
			var diferenca:Vector2 = self.pos - dino.pos
			diferenca = diferenca/(distancia * distancia)
			direcionar += diferenca
			total += 1
	if total > 0:
		direcionar = direcionar/total
		direcionar = direcionar.normalized() * maxVel
		direcionar = direcionar - self.vel
		direcionar = direcionar.limit_length(maxFor)
	return direcionar.normalized()

##função responsavel por retornar um vetor que indica a direção que os dinos precisam andar para se manter em bando.
func coagir(dinos:Array) -> Vector2:
	var raioDePercepcao:float = colisao_da_area.shape.radius
	var direcionar:Vector2 = Vector2.ZERO
	var total:int = 0
	for dino:DINO in dinos:
		var distancia:float = self.pos.distance_to(dino.pos)
		if dino != self && distancia < raioDePercepcao:
			direcionar += dino.pos
			total += 1
	if total > 0:
		direcionar = direcionar/total
		direcionar = direcionar - self.pos
		direcionar = direcionar.normalized() * maxVel
		direcionar = direcionar - self.vel
		direcionar = direcionar.limit_length(maxFor)
	return direcionar.normalized()

func rebanho(dinos:Array) -> void:
	var alinhamento:Vector2 = self.alinhar(dinos)
	var coesao:Vector2 = self.coagir(dinos)
	var separacao:Vector2 = self.separar(dinos)
	
	self.ace += alinhamento + coesao + separacao
	
	self.pos = position

##função responsavel pelo calculo de fisica do dino.
func no_processamento_de_fisica(_delta:float,dinos:Array) -> void:
	self.pos = position
	self.vel += self.ace
	self.vel.limit_length(self.maxVel)
	ativar_movimentacao(vel,dinos)
	
	
	
	
