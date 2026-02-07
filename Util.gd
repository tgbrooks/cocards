class_name Util extends Node


static func format_heat(heat) -> String:
	return '🔥'.repeat(heat)
static func format_oil(oil) -> String:
	return '💧'.repeat(oil)
static func format_work(work) -> String:
	return '🔧'.repeat(work)
static func format_resources(heat, oil, work) -> String:
	var heats = format_heat(heat)
	var oils = format_oil(oil)
	var works = format_work(work)
	return "%s%s%s" % [heats, oils, works]
