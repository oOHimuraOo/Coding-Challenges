class_name ESTRELA
extends Node2D

var x:float
var y:float
var z:float

var vZ:float

var tDT:Vector2

var sx
var sy
var r
var px
var py

func _init(tamanhoDaTela:Vector2) -> void:
	randomize()
	self.tDT = tamanhoDaTela
	self.x = randf_range(-tDT.x, tDT.x)
	self.y = randf_range(-tDT.y, tDT.y)
	self.z = tDT.x
	self.vZ = z

func atualizar(velocidade:float) -> void:
	randomize()
	self.z = z - randf_range(velocidade/10,velocidade)
	if self.z < 1:
		self.z = self.tDT.x
		self.x = randf_range(-tDT.x, self.tDT.x)
		self.y = randf_range(-tDT.y, self.tDT.y)
		self.vZ = self.z

func revelar() -> void:
	sx = remap(self.x/self.z, 0, 1, 0, self.tDT.x)
	sy = remap(self.y/self.z, 0, 1, 0, self.tDT.y)
	
	r = remap(self.z, 0, self.tDT.x, 8, 0)
	
	px = remap(self.x/self.z, 0, 1, 0, self.tDT.x)
	py = remap(self.y/self.z, 0, 1, 0, self.tDT.y)
	
	self.vZ = self.z
	
