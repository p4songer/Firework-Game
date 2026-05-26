extends Node

func get_color_cost(grain_count: int) -> float:
	return float(grain_count) * 0.01

func get_effect_cost(step_count: int) -> float:
	return float(step_count) * 1.125
