class_name POLIGONO
extends Node2D

var vertices:Array = []
var bordas:Array = []

func criarFormaGeometricaRegular(N: int, T: float, X: float, Y: float) -> Array:
	var vertices = []

	# Calcular o ângulo entre cada vértice
	var angulo_interno = (2 * PI) / N

	# Deslocamento de 45 graus
	var deslocamento = PI / 4

	# Gerar os vértices da forma geométrica regular
	for i in range(N):
		var angulo_atual = (i * angulo_interno) + deslocamento  # Calcular o ângulo atual com deslocamento de 45 graus
		var x = T * cos(angulo_atual) + X  # Calcular a coordenada x com ajuste
		var y = T * sin(angulo_atual) + Y  # Calcular a coordenada y com ajuste
		vertices.append(Vector2(x, y))  # Adicionar o vértice à lista
	
	
	print(vertices)
	return vertices


func adicionar_vertice_regular(pontos:Array) -> void:
	var inclusos = []
	for i in range(pontos.size()-1):
		var pontoA = pontos[i]
		var pontoB = pontos[i+1]
		#if !inclusos.has(pontoA) && !inclusos.has(pontoB):
		var borda:BORDA = BORDA.new(pontos[i], pontos[i+1])
		bordas.append(borda)
		vertices.append(pontos[i])
		inclusos.append(pontoA)
		inclusos.append(pontoB)
	
func criar_poligono_regular(numeroDeLados:int,x:float,y:float,incremento:float, cor1, cor2):
	if numeroDeLados == 4:
			var novoX = x * incremento
			var novoY = y * incremento
			self.adicionar_vertice(novoX,novoY, cor1, cor2)
			self.adicionar_vertice(novoX + incremento, novoY, cor1, cor2)
			self.adicionar_vertice(novoX + incremento, novoY + incremento , cor1, cor2)
			self.adicionar_vertice(novoX, novoY + incremento, cor1, cor2)
	else:
		var novoX = x * incremento
		var novoY = y * incremento
		var raio = incremento / 2
		var centro = Vector2((novoX)/2,(novoY)/2)

		var angulo_inicial = -PI/2
		var angulo_incremento = 2 * PI / numeroDeLados
		var angulos = []
		for i in range(numeroDeLados):
			angulos.append(angulo_inicial + i * angulo_incremento)

		var pontos = []
		for angulo in angulos:
			var ponto_x = centro.x + raio * cos(angulo)
			var ponto_y = centro.y + raio * sin(angulo)
			pontos.append(Vector2(ponto_x, ponto_y))
		
		for i in range(pontos.size()):
			self.adicionar_vertice(pontos[i].x + novoX/2.2, pontos[i].y + novoY/2.2, cor1, cor2)


func adicionar_vertice(x:float,y:float, c1:Color, c2:Color) -> void:
	var a:Vector2 = Vector2(x,y)
	var total:int = self.vertices.size()
	if total > 0:
		var anterior:Vector2 = self.vertices[total - 1]
		var borda:BORDA = BORDA.new(anterior, a,2,c1)
		self.bordas.append(borda)
	self.vertices.append(a)

func fechar(c1:Color,c2:Color) -> void:
	var total:int = self.vertices.size()
	var ultimo:Vector2 = self.vertices[total-1]
	var primeiro:Vector2 = self.vertices[0] 
	var borda:BORDA = BORDA.new(ultimo,primeiro, 2, c1)
	self.bordas.append(borda)
	self.vertices.append(primeiro)
	#for i in bordas:
		#i.hide()

func criar_hankin(angulo:float,delta:float,c1:Color,c2:Color) -> void:
	for borda:BORDA in bordas:
		borda.revelar(self)
		borda.criar_hankin(angulo, delta, c1, c2)
	
	for i in range(self.bordas.size()):
		for j in range(self.bordas.size()):
			if i != j:
				self.bordas[i].encontrarFim(self.bordas[j])
	
	for borda:BORDA in bordas:
		borda.hankin_1.revelar(borda)
		borda.hankin_2.revelar(borda)
