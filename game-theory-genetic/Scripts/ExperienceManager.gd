extends Node2D

@export var Gamblers : Array[Gambler] = []
var number : int = 100
var roundTimer := 0

func _ready() -> void:
	for i in range(number):
		var newGambler = Gambler.new()
		newGambler.initializeMemory()
		newGambler.randomChromosomes()
		Gamblers.append(newGambler)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	roundTimer -= delta
	if (roundTimer<=0):
		playGeneration()
		roundTimer = 1
		reproduce_new_generation()
		print(get_best_gamblers(1)[0].chromosomes)

func playGeneration():
	var pool :Array[Gambler] = []
	var subpool : Array[Gambler] = []
	pool = Gamblers.duplicate()
	for g in Gamblers:
		subpool = pool.duplicate()
		subpool.erase(g)
		for e in subpool:
			var choice = (randi() % 3)-1
			var oppchoice = (randi() % 3)-1
			for r in range(10):
				g.updateMemory(r,oppchoice)
				e.updateMemory(r,choice)
				choice =g.fight()
				oppchoice = e.fight()
				g.addMoney(findResult(choice,oppchoice))
				e.addMoney(findResult(oppchoice,choice))
		pool.erase(g)


func findResult(me, other):
	if(me>other):
		return 5
	elif(other> me):
		return 0
	elif(me == 1):
		return 3
	else:
		return 1

func get_best_gamblers(count:int) -> Array[Gambler]:
	var sorted = Gamblers.duplicate()
	sorted.sort_custom(func(a, b): return a.Money > b.Money)
	return sorted.slice(0, count)


func reproduce_new_generation():
	var best := get_best_gamblers(10)
	var new_population : Array[Gambler] = []

	for g in best:
		var clone = Gambler.new()
		clone.chromosomes = g.chromosomes.duplicate()
		clone.reset()
		new_population.append(clone)

	while new_population.size() < number:
		var parent_a = best.pick_random()
		var parent_b = best.pick_random()
		if parent_a != parent_b:
			var child = parent_a.reproduction(parent_b)
			new_population.append(child)

	Gamblers = new_population
