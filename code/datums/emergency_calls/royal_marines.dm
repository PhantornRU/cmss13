/datum/emergency_call/royal_marines
	name = "Royal Marines Commando (Squad) (Friendly)"
	mob_max = 6
	probability = 15
	home_base = /datum/lazy_template/ert/twe_station
	shuttle_id = MOBILE_SHUTTLE_ID_ERT4
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_twe
	item_spawn = /obj/effect/landmark/ert_spawns/distress_twe/item
	max_engineers =  1
	max_medics = 1
	max_heavies = 2

/datum/emergency_call/royal_marines/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], это [pick_weight(list("ККФ \"Патна\"" = 50, "ККФ \"Тандерчайлд\"" = 50))]; мы получили ваш сигнал бедствия и выдвигаемся к вам в соответствии с Законом о военной помощи от 2177 года, код аутентификации Лима-18153."
	objectives = "Обеспечьте безопасность корабля [MAIN_SHIP_NAME], ликвидируйте всех неприятелей и окажите экипажу необходимую поддержку."


/datum/emergency_call/royal_marines/create_member(datum/mind/spawning_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	spawning_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are an Officer in the Royal Marines Commando. Born in the Three World Empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/team_leader, TRUE, TRUE)

	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		var/specialist_kit = pick("Sniper", "Smartgun")
		switch(specialist_kit)
			if("Sniper")
				to_chat(mob, SPAN_ROLE_HEADER("You are a skilled marksman in the Royal Marines Commando. Born in the Three World Empire."))
				arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/spec/marksman, TRUE, TRUE)
			if("Smartgun")
				to_chat(mob, SPAN_ROLE_HEADER("You are a Smartgunner in the Royal Marines Commando. Born in the Three World Empire."))
				arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/spec/machinegun, TRUE, TRUE)
		heavies++

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		to_chat(mob, SPAN_ROLE_HEADER("You are a Corpsman-Surgeon of the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/medic, TRUE, TRUE)
		medics++

	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		to_chat(mob, SPAN_ROLE_HEADER("You are a CQB Specialist in the Royal Marines Commando. Born in the Three World Empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/spec/breacher, TRUE, TRUE)
		engineers++

	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a member of the Royal Marines Commando. Born in the three world empire."))
		arm_equipment(mob, /datum/equipment_preset/twe/royal_marine/standard, TRUE, TRUE)

	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/royal_marines/print_backstory(mob/living/carbon/human/spawning_mob)
	to_chat(spawning_mob, SPAN_BOLD("You were born in the Three World Empire to a [pick_weight(list("average" = 75, "poor" = 15, "well-established" = 10))] family."))
	to_chat(spawning_mob, SPAN_BOLD("Joining the Royal Marines gave you a lot of combat experience and useful skills."))
	to_chat(spawning_mob, SPAN_BOLD("You are [pick_weight(list("unaware" = 70, "faintly aware" = 20, "knowledgeable" = 10))] of the xenomorph threat."))
	to_chat(spawning_mob, SPAN_BOLD("You are a citizen of the three world empire and joined the Royal Marines Commando"))
	to_chat(spawning_mob, SPAN_BOLD("You are apart of a jointed UA/TWE taskforce onboard the HMS Patna and Thunderchild."))
	to_chat(spawning_mob, SPAN_BOLD("Under the directive of the RMC high command, you have been assisting USCM forces with maintaining peace in the area."))
	to_chat(spawning_mob, SPAN_BOLD("Assist the USCMC Force of the [MAIN_SHIP_NAME] however you can."))

/datum/emergency_call/royal_marines/platoon
	name = "Royal Marines Commando (Platoon) (Friendly)"
	mob_min = 7
	mob_max = 28
	probability = 0
	max_medics = 4
	max_heavies = 8
	max_engineers = 4

/obj/effect/landmark/ert_spawns/distress_twe
	name = "Distress_TWE"
	icon_state = "spawn_distress_twe"

/obj/effect/landmark/ert_spawns/distress_twe/item
	name = "Distress_TWEItem"
	icon_state = "distress_item"
