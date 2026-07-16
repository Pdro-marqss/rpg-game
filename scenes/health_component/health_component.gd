class_name HealthComponent extends Node;

signal on_health_changed(curr_health: float);
signal on_dead();

var max_health: float;
var current_health: float;

func setup(max_health_value: float) -> void:
	max_health = max_health_value;
	current_health = max_health_value;


func take_damage(damage_taken: float) -> void:
	if current_health <= 0: return;
	
	current_health = max(current_health - damage_taken, 0);
	on_health_changed.emit(current_health);
	
	if current_health <= 0: on_dead.emit();
