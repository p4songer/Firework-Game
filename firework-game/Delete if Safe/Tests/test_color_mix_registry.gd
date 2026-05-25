## Smoke test script for Color Mix Registry API
extends Node

func _ready() -> void:
	print("=== Color Mix Registry Smoke Test ===")
	
	# Test 1: Verify default mixes were seeded in Global._ready()
	print("\nTest 1: Checking default mixes...")
	var crimson = Global.get_mix("CrimsonBurst")
	print("CrimsonBurst: ", crimson)
	assert(crimson.has("cost") and crimson["cost"] == 10.0, "CrimsonBurst cost mismatch")
	assert(crimson.has("color") and crimson["color"] == Color8(220, 20, 60), "CrimsonBurst color mismatch")
	print("✓ CrimsonBurst verified")
	
	var ocean = Global.get_mix("OceanBlue")
	print("OceanBlue: ", ocean)
	assert(ocean.has("cost") and ocean["cost"] == 8.0, "OceanBlue cost mismatch")
	assert(ocean.has("color") and ocean["color"] == Color8(30, 144, 255), "OceanBlue color mismatch")
	print("✓ OceanBlue verified")
	
	var sunflare = Global.get_mix("Sunflare")
	print("Sunflare: ", sunflare)
	assert(sunflare.has("cost") and sunflare["cost"] == 12.5, "Sunflare cost mismatch")
	assert(sunflare.has("color") and sunflare["color"] == Color8(255, 180, 25), "Sunflare color mismatch")
	print("✓ Sunflare verified")
	
	# Test 2: Add new mix
	print("\nTest 2: Adding new mix...")
	Global.add_mix("TestMix", 5.5, Color8(10, 200, 100))
	var test_mix = Global.get_mix("TestMix")
	print("TestMix: ", test_mix)
	assert(test_mix.has("cost") and test_mix["cost"] == 5.5, "TestMix cost mismatch")
	assert(test_mix.has("color") and test_mix["color"] == Color8(10, 200, 100), "TestMix color mismatch")
	print("✓ TestMix added successfully")
	
	# Test 3: Remove mix
	print("\nTest 3: Removing mix...")
	Global.remove_mix("TestMix")
	var removed_mix = Global.get_mix("TestMix")
	print("After removal: ", removed_mix)
	assert(removed_mix.is_empty(), "TestMix should be empty after removal")
	print("✓ TestMix removed successfully")
	
	# Test 4: mix_exists
	print("\nTest 4: Checking mix_exists...")
	assert(Global.mix_exists("CrimsonBurst"), "CrimsonBurst should exist")
	assert(not Global.mix_exists("NonExistent"), "NonExistent should not exist")
	print("✓ mix_exists works correctly")
	
	# Test 5: list_mixes
	print("\nTest 5: Listing all mixes...")
	var mixes = Global.list_mixes()
	print("All mixes: ", mixes)
	assert(mixes.has("CrimsonBurst"), "CrimsonBurst should be in list")
	assert(mixes.has("OceanBlue"), "OceanBlue should be in list")
	assert(mixes.has("Sunflare"), "Sunflare should be in list")
	assert(mixes.size() == 3, "Should have exactly 3 default mixes")
	print("✓ list_mixes works correctly")
	
	print("\n=== All Smoke Tests Passed ===")
	get_tree().quit()
