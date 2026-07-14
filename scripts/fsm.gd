extends Node;
class_name FSM; # Finit State Machine

signal on_state_transitioned(state_name: String);

@export var initial_state: NodePath;

var current_state: State;

func _ready() -> void:
	await owner.ready;
	
	for state: State in get_children():
		# Salvando dentro de cada estado uma referencia/instancia dessa classe de controle de estado (dando acesso as funcoes)
		state.fsm = self;
		
	current_state = get_node(initial_state);
	current_state.enter_state();


# Muda para outro estado
func transition_to(state_name: String) -> void:
	if not has_node(state_name):
		return;
	
	current_state.exit_state();
	current_state = get_node(state_name);
	current_state.enter_state();
	on_state_transitioned.emit(current_state.name);
