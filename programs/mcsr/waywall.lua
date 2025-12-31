package.path = package.path .. ";@waywork@/?.lua"

local waywall = require("waywall")
local helpers = require("waywall.helpers")

local Scene = require("waywork.scene")
local Modes = require("waywork.modes")
local Keys = require("waywork.keys")
local Processes = require("waywork.processes")

local scene = Scene.SceneManager.new(waywall)
local ModeManager = Modes.ModeManager.new(waywall)

local eye_dst = { x = 0, y = 317.5, w = 790, h = 444.375 }

-- https://arjuncgore.github.io/waywall-boat-eye-calc/
-- https://github.com/Esensats/mcsr-calcsens
local normal_sens = 13.117018998967824
local tall_sens = 0.88486625532087

scene:register("eye_measure", {
	kind = "mirror",
	options = {
		src = { x = 140, y = 7902, w = 60, h = 580 },
		dst = eye_dst,
	},
	groups = { "tall" },
})

scene:register("eye_overlay", {
	kind = "image",
	path = "@eye-overlay@",
	options = { dst = eye_dst },
	groups = { "tall" },
})

ModeManager:define("thin", {
	width = 340,
	height = 1080,
	toggle_guard = function()
		return not waywall.get_key("F3") and waywall.state().screen == "inworld"
	end,
})

ModeManager:define("tall", {
	width = 340,
	height = 16384,
	on_enter = function()
		scene:enable_group("tall", true)
		waywall.set_sensitivity(tall_sens)
	end,
	on_exit = function()
		scene:enable_group("tall", false)
		waywall.set_sensitivity(normal_sens)
	end,
	toggle_guard = function()
		return not waywall.get_key("F3") and waywall.state().screen == "inworld"
	end,
})

ModeManager:define("wide", {
	width = 1920,
	height = 300,
	toggle_guard = function()
		return not waywall.get_key("F3") and waywall.state().screen == "inworld"
	end,
})

local ensure_ninjabrain = Processes.ensure_application(waywall, "@ninjabrain@")("ninjabrain.*\\.jar")

local config = {
	input = {
		layout = "fr",
		repeat_rate = 40,
		repeat_delay = 300,

		sensitivity = normal_sens,
		confine_pointer = false,
	},
	theme = {
		background = "#303030ff",
		ninb_anchor = "right",
	},
	actions = Keys.actions({
		["Ctrl-Super-F"] = waywall.toggle_fullscreen,
		["*-N"] = function()
			return ModeManager:toggle("thin")
		end,
		["*-P"] = function()
			return ModeManager:toggle("tall")
		end,
		["*-G"] = function()
			return ModeManager:toggle("wide")
		end,
		["Ctrl-Shift-M"] = function()
			ensure_ninjabrain()
			helpers.toggle_floating()
		end,
	}),
}

return config
