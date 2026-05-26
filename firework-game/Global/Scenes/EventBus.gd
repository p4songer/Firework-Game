extends Node

@warning_ignore("unused_signal")
signal color_changed(new_color: Color)
@warning_ignore("unused_signal")
signal star_finished_emitting() # Revisit. Might be safe to delete.
# @warning_ignore("unused_signal") 
# signal launch_firework() # Both connections in "delete if safe"
# @warning_ignore("unused_signal")
# signal request_ingredient(requestor: Node2D) # No connections found.
# @warning_ignore("unused_signal")
# signal part_finished() Only connection in "delete if safe"
# @warning_ignore("unused_signal")
# signal color_button_pressed() # No connections found.
# @warning_ignore("unused_signal")
# signal effect_button_pressed() # No connections found.
# @warning_ignore("unused_signal")
# signal prepare_launch() # One connection in delete if safe
@warning_ignore("unused_signal")
signal firework_finished()
@warning_ignore("unused_signal")
signal qte_clicked(data: NPC_Resource)
@warning_ignore("unused_signal")
signal spin_finished()
@warning_ignore("unused_signal")
signal attempt_ingredient(ing_name: String)
@warning_ignore("unused_signal")
signal new_grain(grain: Node2D)
@warning_ignore("unused_signal")
signal notebook_updated(npc: NPC_Resource)
@warning_ignore("unused_signal")
signal customer_selected(npc: NPC_Resource)
@warning_ignore("unused_signal")
signal craft_stars_completed(final_color: Color)
@warning_ignore("unused_signal")
signal star_minigame_completed(effect: IngredientResource.EFFECTS, success: bool)
@warning_ignore("unused_signal")
signal customers_cleared()
@warning_ignore("unused_signal")
signal firework_assembled(firework: FireworkResource)
@warning_ignore("unused_signal")
signal room_changed()
@warning_ignore("unused_signal")
signal display_started()
