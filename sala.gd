extends Node2D

# -REFERÊNCIAS-
@onready var painel = $Interface/CenterContainer
@onready var label_texto = $Interface/CenterContainer/PanelContainer/MarginContainer/Label
@onready var timer = $Timer
var tween_atual: Tween

# -ESTADOS (interruptor lógico da Porta)-
var verificou_porta = false

func _ready():
	# Esconde o painel inicialmente
	if painel != null: painel.visible = false
	
	# Roda intro, caso ainda não tenha ocorrido
	if Global.ja_viu_intro == false:
		await get_tree().create_timer(1.0).timeout
		exibir_texto("Minha cabeça dói... Preciso dar um jeito de sair daqui.", 2.0)
		
		# Marca na memória global que a intro ocorreu
		Global.ja_viu_intro = true


# -FUNÇÃO AUXILIAR-
func exibir_texto(mensagem: String, tempo_leitura: float):
	timer.stop() # Para temporizadores antigos
	if tween_atual: 
		tween_atual.kill()
	
	# Configura o novo texto
	painel.visible = true
	label_texto.text = mensagem
	label_texto.visible_ratio = 0.0
	
	# Cria a nova animação e guarda na variável
	tween_atual = create_tween()
	tween_atual.tween_property(label_texto, "visible_ratio", 1.0, 1.0)
	
	# Configura o novo temporizador
	timer.wait_time = tempo_leitura
	tween_atual.tween_callback(timer.start)


# -EVENTO DA PORTA-
func _on_porta_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		if Global.tem_chave == true:
			exibir_texto("A chave funcionou! Hora de sair daqui.", 2.0)
			
			await get_tree().create_timer(2.0).timeout
			
			Global.resetar_memoria() # Zera a chave e a flag da intro
			
			# Reinicia o jogo (fecha o loop)
			Transicao.mudar_cena("res://Sala.tscn")
			
		else:
			# Comportamento padrão (sem chave)
			verificou_porta = true # Interruptor lógico ativado (personagem agora sabe que a porta está trancada e procurará pela chave)
			exibir_texto("A porta está trancada. Talvez a chave esteja por aqui em algum lugar.", 2.0)

func _on_janela_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		exibir_texto("Estou no 4º andar, acho que pular a janela não é uma opção...", 2.0)

func _on_lareira_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		exibir_texto("Uma bela lareira, ainda há brasas quentes... Não estou sozinho.", 2.0)

func _on_quadro_1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		exibir_texto("Uma paisagem bonita em tinta a óleo, assinado por... R. B.", 2.0)

func _on_quadro_2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		exibir_texto("Um retrado de um menino e seu cachorro, está 'Vini e Anke' com a caligrafia de uma criança.", 2.0)

# -EVENTO DO GAVETEIRO-
func _on_gaveta_interativa_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# Dependência de inteção (Porta)
		if verificou_porta == true:
			# Com a porta ja vista, o jogo progride
			exibir_texto("Será que está em alguma dessas gavetas?", 1.5)
			await get_tree().create_timer(1.5).timeout
			Transicao.mudar_cena("res://GavetaCloseUp.tscn")
			
		else:
			# Falta verificar a porta para ter contexto
			exibir_texto("Esse gaveteiro já viu dias melhores.", 2.0)

func _on_timer_timeout():
	painel.visible = false
