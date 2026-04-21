extends RefCounted
class_name RewardGen

const STAT_MIN: float = 2.2
const STAT_MAX: float = 10.0
const STAT_COUNT: int = 5


const MIN_TOTALS := {
	PartInstance.Rarity.COMMON: 18.0,
	PartInstance.Rarity.UNCOMMON: 24.0,
	PartInstance.Rarity.RARE: 31.0,
	PartInstance.Rarity.EPIC: 36.0,
	PartInstance.Rarity.LEGENDARY: 41.0
}

const MAX_TOTALS := {
	PartInstance.Rarity.COMMON: 23.9,
	PartInstance.Rarity.UNCOMMON: 30.9,
	PartInstance.Rarity.RARE: 35.9,
	PartInstance.Rarity.EPIC: 40.9,
	PartInstance.Rarity.LEGENDARY: 47.0
}
const INDIVIDUAL_MIN := {
	PartInstance.Rarity.COMMON: 2.0,
	PartInstance.Rarity.UNCOMMON: 2.2,
	PartInstance.Rarity.RARE: 2.5,
	PartInstance.Rarity.EPIC: 2.9,
	PartInstance.Rarity.LEGENDARY: 3.4
}

const INDIVIDUAL_MAX := {
	PartInstance.Rarity.COMMON: 6.0,
	PartInstance.Rarity.UNCOMMON: 7.5,
	PartInstance.Rarity.RARE: 9.0,
	PartInstance.Rarity.EPIC: 10.0,
	PartInstance.Rarity.LEGENDARY: 10.0
}

static func roll_rarity() -> int:
	var roll: float = randf() * 100.0

	if roll < 45.0:
		return PartInstance.Rarity.COMMON
	elif roll < 75.0:
		return PartInstance.Rarity.UNCOMMON
	elif roll < 90.0:
		return PartInstance.Rarity.RARE
	elif roll < 98.0:
		return PartInstance.Rarity.EPIC
	else:
		return PartInstance.Rarity.LEGENDARY

static func make_random_part(item: ItemData) -> PartInstance:
	var p := PartInstance.new()
	p.initialize_from_item(item)
	p.rarity = roll_rarity()

	var min_total: float = float(MIN_TOTALS.get(p.rarity, 18.0))
	var max_total: float = float(MAX_TOTALS.get(p.rarity, 25.0))
	var min_stat: float = float(INDIVIDUAL_MIN.get(p.rarity, 2.0))
	var max_stat: float = float(INDIVIDUAL_MAX.get(p.rarity, 6.0))

	var rolled_total: float = snappedf(randf_range(min_total, max_total), 0.1)
	var stats: Array[float] = _generate_stats_for_range(rolled_total, min_stat, max_stat)

	p.aerodynamics = stats[0]
	p.weight = stats[1]
	p.cost = stats[2]
	p.repairability = stats[3]
	p.acceleration = stats[4]

	p.shop_price = _calculate_shop_price(p)
	return p
static func _calculate_shop_price(part: PartInstance) -> int:
	var total: float = part.get_total_stats()

	match part.rarity:
		PartInstance.Rarity.COMMON:
			return 5

		PartInstance.Rarity.UNCOMMON:
			return _scale_price(total, 26.0, 30.0, 7, 8)

		PartInstance.Rarity.RARE:
			return _scale_price(total, 30.0, 36.0, 12, 15)

		PartInstance.Rarity.EPIC:
			return _scale_price(total, 36.0, 42.0, 19, 22)

		PartInstance.Rarity.LEGENDARY:
			return 35

	return 5
static func _generate_stats_for_range(target_total: float, min_stat: float, max_stat: float) -> Array[float]:
	var stats: Array[float] = []
	stats.resize(STAT_COUNT)

	# Start each stat at the minimum
	for i in range(STAT_COUNT):
		stats[i] = min_stat

	var remaining: float = target_total - (min_stat * STAT_COUNT)
	if remaining <= 0.0:
		for i in range(STAT_COUNT):
			stats[i] = snappedf(stats[i], 0.1)
		return stats

	var capacities: Array[float] = []
	capacities.resize(STAT_COUNT)
	for i in range(STAT_COUNT):
		capacities[i] = max_stat - min_stat

	var weights: Array[float] = []
	weights.resize(STAT_COUNT)

	var weight_sum: float = 0.0
	for i in range(STAT_COUNT):
		var w: float = randf_range(0.2, 1.0)
		weights[i] = w
		weight_sum += w

	for i in range(STAT_COUNT):
		var add_amount: float = remaining * (weights[i] / weight_sum)
		add_amount = min(add_amount, capacities[i])
		stats[i] += add_amount

	var current_total: float = _sum_stats(stats)
	var diff: float = target_total - current_total
	var safety: int = 0

	while abs(diff) > 0.05 and safety < 300:
		safety += 1

		if diff > 0.0:
			var candidates_up: Array[int] = []
			for i in range(STAT_COUNT):
				if stats[i] < max_stat - 0.001:
					candidates_up.append(i)

			if candidates_up.is_empty():
				break

			var up_index: int = candidates_up[randi() % candidates_up.size()]
			var up_step: float = min(diff, 0.1, max_stat - stats[up_index])
			stats[up_index] += up_step
		else:
			var candidates_down: Array[int] = []
			for i in range(STAT_COUNT):
				if stats[i] > min_stat + 0.001:
					candidates_down.append(i)

			if candidates_down.is_empty():
				break

			var down_index: int = candidates_down[randi() % candidates_down.size()]
			var down_step: float = min(-diff, 0.1, stats[down_index] - min_stat)
			stats[down_index] -= down_step

		diff = target_total - _sum_stats(stats)

	for i in range(STAT_COUNT):
		stats[i] = snappedf(clampf(stats[i], min_stat, max_stat), 0.1)

	return stats
static func _scale_price(total: float, min_total: float, max_total: float, min_price: int, max_price: int) -> int:
	if max_total <= min_total:
		return min_price

	var t: float = inverse_lerp(min_total, max_total, total)
	t = clampf(t, 0.0, 1.0)
	return int(round(lerpf(float(min_price), float(max_price), t)))

static func _generate_stats_for_target(target_total: float) -> Array[float]:
	var stats: Array[float] = []
	stats.resize(STAT_COUNT)

	for i in range(STAT_COUNT):
		stats[i] = STAT_MIN

	var remaining: float = target_total - (STAT_MIN * STAT_COUNT)
	if remaining <= 0.0:
		return stats

	var capacities: Array[float] = []
	capacities.resize(STAT_COUNT)
	for i in range(STAT_COUNT):
		capacities[i] = STAT_MAX - STAT_MIN

	var weights: Array[float] = []
	weights.resize(STAT_COUNT)

	var weight_sum: float = 0.0
	for i in range(STAT_COUNT):
		var w: float = randf_range(0.2, 1.0)
		weights[i] = w
		weight_sum += w

	for i in range(STAT_COUNT):
		var add_amount: float = remaining * (weights[i] / weight_sum)
		add_amount = min(add_amount, capacities[i])
		stats[i] += add_amount

	var current_total: float = _sum_stats(stats)
	var diff: float = target_total - current_total

	var safety: int = 0
	while abs(diff) > 0.05 and safety < 200:
		safety += 1

		if diff > 0.0:
			var candidates_up: Array[int] = []
			for i in range(STAT_COUNT):
				if stats[i] < STAT_MAX - 0.001:
					candidates_up.append(i)

			if candidates_up.is_empty():
				break

			var up_index: int = candidates_up[randi() % candidates_up.size()]
			var up_step: float = min(diff, 0.1, STAT_MAX - stats[up_index])
			stats[up_index] += up_step
		else:
			var candidates_down: Array[int] = []
			for i in range(STAT_COUNT):
				if stats[i] > STAT_MIN + 0.001:
					candidates_down.append(i)

			if candidates_down.is_empty():
				break

			var down_index: int = candidates_down[randi() % candidates_down.size()]
			var down_step: float = min(-diff, 0.1, stats[down_index] - STAT_MIN)
			stats[down_index] -= down_step

		diff = target_total - _sum_stats(stats)

	for i in range(STAT_COUNT):
		stats[i] = snappedf(clampf(stats[i], STAT_MIN, STAT_MAX), 0.1)

	diff = snappedf(target_total - _sum_stats(stats), 0.1)
	if abs(diff) >= 0.1:
		for i in range(STAT_COUNT):
			if diff > 0.0 and stats[i] + diff <= STAT_MAX:
				stats[i] = snappedf(stats[i] + diff, 0.1)
				break
			elif diff < 0.0 and stats[i] + diff >= STAT_MIN:
				stats[i] = snappedf(stats[i] + diff, 0.1)
				break

	return stats

static func _sum_stats(stats: Array[float]) -> float:
	var total: float = 0.0
	for value in stats:
		total += value
	return total
