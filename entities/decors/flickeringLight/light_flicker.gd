extends SpotLight3D

@export var lightBulbMaterial : StandardMaterial3D
@export var noise : FastNoiseLite

# Change flickering frequency by changing fast noise frequency in editor
# Change light energy also in editor

# Light energy before starting
var maxLightEnergy : float

func _ready() -> void:
	maxLightEnergy = light_energy

var time := 0.0
func _process(delta: float) -> void:
	time += delta
	light_energy = maxLightEnergy*(noise.get_noise_1d(time*50)+1)/2
	lightBulbMaterial.emission_energy_multiplier = light_energy 
	
