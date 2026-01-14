extends Node
class_name Gambler

var Money := 0
var chromosomes : Array
var memory : Array 

func initializeMemory():
	memory = []
	for i in range(10):
		memory.append(0)

func randomChromosomes():
	chromosomes = []
	for i in range(10):
		chromosomes.append((randf() *2)-1)

func choose_action():
	var choice = 0.0
	for i in range(memory.size()):
		choice += memory[i] * chromosomes[i]
	
	if(choice < 0):
		return -1
	else:
		return 1

func updateMemory(round, oppChoice):
	memory[round] = oppChoice

func fight():
	var choice = choose_action()
	return choice

func reproduction(love):
	var child = Gambler.new()
	child.chromosomes = []
	for i in range(chromosomes.size()):
		if randf() < 0.5:
			child.chromosomes.append(chromosomes[i])
		else:
			child.chromosomes.append(love.chromosomes[i])
		
		if randf() < 0.05:
			child.chromosomes[i] = (randf() *2)-1
	child.initializeMemory()
	return child

func getMoney():
	return Money
	
func addMoney(gain):
	Money+=gain

func reset():
	Money = 0
	initializeMemory()
