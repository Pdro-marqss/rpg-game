extends CharacterBody2D;
class_name Player;

@export_group("Stats")
@export var max_health: float = 10.0;
@export var max_mana: float = 10.0;
@export var move_speed: float = 60.0;
@export var damage: float = 5.0;
@export var crit_chance: float = 0.0;
@export var crit_damage: float = 0.0;

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite;
@onready var health_component: HealthComponent = $HealthComponent;
@onready var fsm: FSM = $FSM;

var curr_mana: float;
var last_direction: String = "down";


func _process(delta: float) -> void:
	if fsm.current_state:
		fsm.current_state.process_state(delta);

	
func is_moving() -> bool:
	var move_input = ["move_down", "move_up", "move_left", "move_right"];
	
	for input in move_input:
		if Input.is_action_pressed(input):
			return true;
	
	return false;


func update_direction(input_vector: Vector2) -> void:
	# Player parado	
	if input_vector == Vector2.ZERO:
		return;
		
	# Player andando para direita ou esquerda (horizontalmente)
	if abs(input_vector.x) > abs(input_vector.y):
		last_direction = "right" if input_vector.x > 0 else "left"; #Exemplo de ternario
	else:
		# Player andando para cima ou baixo (verticalmente)
		last_direction = "down" if input_vector.y > 0 else "up";


func play_direction_anim(anim_name: String) -> void:
	# Duas formas de fazer:
	# anim_sprite.play(anim_name + "_"  + last_direction);
	anim_sprite.play("%s_%s" % [anim_name, last_direction]);


func setup() -> void:
	reset_health();
	reset_mana();
		

func reset_health() -> void:
	health_component.setup(max_health);
	EventBus.on_player_health_updated.emit(max_health, max_health);


func reset_mana() -> void:
	curr_mana = max_mana;
	EventBus.on_player_mana_updated.emit(max_mana, max_mana);


func use_mana(mana_used_value: float) -> void:
	curr_mana -= mana_used_value;
	curr_mana = max(curr_mana, 0);
	EventBus.on_player_mana_updated.emit(curr_mana, max_mana);
