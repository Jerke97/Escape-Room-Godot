extends Node2D

# -REFERÊNCIAS-
@onready var painel = $Interface/CenterContainer
@onready var label_texto = $Interface/CenterContainer/PanelContainer/MarginContainer/Label
@onready var chave = $Chave
@onready var timer = $Timer

# Variável para controlar animações sobrepostas
var tween_atual: Tween

func _ready():
	# Esconde o painel no início
	if painel != null: painel.visible = false 
	
	# Verifica a memória (evita duplicidade do item)
	if Global.tem_chave == true:
		chave.visible = false
		chave.process_mode = Node.PROCESS_MODE_DISABLED


# -FUNÇÃO INTELIGENTE DE TEXTO (Copiada da Sala)-
func exibir_texto(mensagem: String, tempo_leitura: float):
	# Para qualquer timer ou animação anterior
	timer.stop()
	if tween_atual: tween_atual.kill()
	
	# Configura visual
	painel.visible = true
	label_texto.text = mensagem
	label_texto.visible_ratio = 0.0
	
	# Cria animação de digitação
	tween_atual = create_tween()
	tween_atual.tween_property(label_texto, "visible_ratio", 1.0, 1.5)
	
	# Configura o tempo para sumir depois de digitar toda a mensagem
	timer.wait_time = tempo_leitura
	tween_atual.tween_callback(timer.start)


# -INTERAÇÃO DA CHAVE-
func _on_chave_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Atualiza a memória global
		Global.tem_chave = true
		
		# Feedback Visual (Chave some)
		chave.visible = false
		
		exibir_texto("Espero que essa seja a chave certa.", 2.0)


# -BOTÃO VOLTAR-
func _on_area_voltar_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Transicao.mudar_cena("res://Sala.tscn")


# -QUANDO O TEMPO ACABA-
func _on_timer_timeout():
	painel.visible = false
