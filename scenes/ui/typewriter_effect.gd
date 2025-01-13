class_name TypewriterEffect extends Label


func typewriter_effect(duration : float = 2) -> void:
	var timeElapsed = 0
	while timeElapsed < duration:
		visible_ratio = lerp(0,1, timeElapsed / duration)
		timeElapsed += get_process_delta_time()
		await get_tree().create_timer(get_process_delta_time() * 2.5).timeout
		print(visible_ratio)
		
		
		
