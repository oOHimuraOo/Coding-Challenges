class_name COMPLEXOS
extends Node

var a
var b

func incializar_valores(A, B) -> void:
	a = A
	b = B

func somar(outro:COMPLEXOS) -> COMPLEXOS:
	var retorno:Array = [self.a + outro.a, self.b + outro.b]
	var novo_complexo = COMPLEXOS.new()
	novo_complexo.incializar_valores(retorno[0], retorno[1])
	return novo_complexo

func subtrair(outro:COMPLEXOS) -> COMPLEXOS:
	var retorno:Array = [self.a - outro.a, self.b - outro.b]
	var novo_complexo = COMPLEXOS.new()
	novo_complexo.incializar_valores(retorno[0], retorno[1])
	return novo_complexo

func scalonar(valor:float) -> COMPLEXOS:
	var retorno:Array = [self.a * valor, self.b * valor]
	var novo_complexo = COMPLEXOS.new()
	novo_complexo.incializar_valores(retorno[0], retorno[1])
	return novo_complexo

func multiplicar(outro:COMPLEXOS) -> COMPLEXOS:
	var novo_a = self.a * outro.a - self.b * outro.b
	var novo_b = self.a * outro.b + outro.a * self.b
	var novo_complexo = COMPLEXOS.new()
	novo_complexo.incializar_valores(novo_a, novo_b)
	return novo_complexo

func raizQuadrada() -> COMPLEXOS:
	var magnitude = sqrt(self.a * self.a + self.b * self.b)
	var angle = atan2(self.b, self.a)
	magnitude = sqrt(magnitude)
	angle = angle/2
	var novo_complexo = COMPLEXOS.new()
	novo_complexo.incializar_valores(magnitude * cos(angle), magnitude * sin(angle))
	return novo_complexo
