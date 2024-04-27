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

	# Reorganizar os vértices para que comecem pelos vértices superiores e sigam no sentido horário
	var metade = N / 4  # Calcula a metade dos vértices
	var superior = vertices.slice(metade, N)  # Vértices superiores
	var direita = vertices.slice(0, metade)  # Vértices do lado direito
	var inferior = vertices.slice(0, metade)  # Vértices inferiores (revertidos)
	var esquerda = vertices.slice(metade, N)  # Vértices do lado esquerdo (revertidos)
	inferior.reverse()
	esquerda.reverse()
	# Organiza os vértices na ordem correta
	vertices = superior + direita + inferior + esquerda

	return vertices


func adicionar_vertice_regular(pontos:Array) -> void:
	for i in range(pontos.size()-1):
		var borda:BORDA = BORDA.new(pontos[i], pontos[i+1])
		bordas.append(borda)
		vertices.append(pontos[i])

func adicionar_vertice(x:float,y:float) -> void:
	var a:Vector2 = Vector2(x,y)
	var total:int = self.vertices.size()
	if total > 0:
		var anterior:Vector2 = self.vertices[total - 1]
		var borda:BORDA = BORDA.new(anterior, a)
		self.bordas.append(borda)
	self.vertices.append(a)

func fechar() -> void:
	var total:int = self.vertices.size()
	var ultimo:Vector2 = self.vertices[total-1]
	print(vertices)
	print(ultimo)
	var primeiro:Vector2 = self.vertices[0]
	print(primeiro)
	var borda:BORDA = BORDA.new(ultimo,primeiro)
	self.bordas.append(borda)
	self.vertices.append(primeiro)

func criar_hankin(angulo:float,delta:float) -> void:
	for borda:BORDA in bordas:
		borda.revelar(self)
		borda.criar_hankin(angulo, delta)
	
	for i in range(self.bordas.size()):
		for j in range(self.bordas.size()):
			if i != j:
				self.bordas[i].encontrarFim(self.bordas[j])
	
	for borda:BORDA in bordas:
		borda.hankin_1.revelar(borda)
		borda.hankin_2.revelar(borda)
