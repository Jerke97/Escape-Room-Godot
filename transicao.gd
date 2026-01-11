extends CanvasLayer

@onready var anim = $AnimationPlayer
@onready var cortina = $ColorRect

func mudar_cena(caminho_da_cena: String):
	# Vinheta bloqueia cliques
	cortina.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Fade out
	anim.play("dissolve")
	
	# Espera a animação terminar
	await anim.animation_finished
	
	# Troca a cena
	get_tree().change_scene_to_file(caminho_da_cena)
	
	# Fade in
	anim.play_backwards("dissolve")
	
	# Libera o mouse
	await anim.animation_finished
	cortina.mouse_filter = Control.MOUSE_FILTER_IGNORE
