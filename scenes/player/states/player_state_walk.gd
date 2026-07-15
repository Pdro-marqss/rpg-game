extends PlayerState;
class_name PlayerStateWalk;

func enter_state() -> void:
	player.play_direction_anim("walk");


func process_state(_delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	
	# Se o player ta parado na animação de Walk, muda pra Idle
	if input_vector == Vector2.ZERO:
		fsm.transition_to("Idle");
		return;
	
	# Atualiza a direção do player antes de mudar pra Walk novamente
	player.update_direction(input_vector);
	player.play_direction_anim("walk");

	player.velocity = input_vector * player.move_speed;
	player.move_and_slide();
