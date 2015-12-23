require "squib"
require "../util"
include Squib

Y_POS = ["0.9in", "1.15in", "1.4in"]

DECK_CONFIG = {
	layout: "layout.yml",
	height: "3.5in", width: "2.5in",
	cards: open_gsheet("../mastersheets/master_module_sheet.gsheet"),
	dpi: 600,
	config: "config.yml"
}

Deck.new(DECK_CONFIG) do
	data = csv file: "cache.csv"
	buffer = data.row_map do |row, new_row|
		new_row["meta"] = [
			row["type"],
			if_truthy(row["gives_flying"]) { "flys" },
			if_truthy(row["gives_digging"]) { "digs" }
		].compact.join ", "

		new_row["meta2"] = [
			if_truthy(row["armor"]){ "#{row['armor']} Amr" },
			if_truthy(row["res"]){ "#{row['res']} Res" },
			if_truthy(row["weight"]){ "#{row['weight']} Weight" }
		].compact.join ", "

		new_row["weapon"] = if_truthy(row["weapon"]) do
			"#{row['weapon_type']} Weapon"
		end

		new_row["weapon_meta"] = [
			if_truthy(row["weapon_dmg"]) { "Damage: #{row['weapon_dmg']}" },
			if_truthy(row["weapon_acc"]) { "Acc: #{row['weapon_acc']}" },
		].compact.join ", "

		new_row["weapon_targets"] = if_truthy(row["weapon_targets"]) do
			"Targets: #{row['weapon_targets']}"
		end

		new_row
	end

	background color: "white"

	rect width: "2.5in", height: "3.5in", stroke_color: :black, stroke_width: 25
	text str: data["name"],          y: "0.2in",          layout: "header"
	text str: buffer["meta"],        y: "0.45in",           layout: "meta"
	text str: buffer["meta2"],       y: "0.63in",          layout: "meta"
	text str: buffer["weapon"],      y: "0.9in",             layout: "subheader"
	text str: buffer["weapon_meta"], y: "1.05in",          layout: "meta"
	text str: buffer["weapon_targets"], y: "1.2in",          layout: "meta"

	text str: data["effects"],        y: "1.5in",           layout: "paragraph"


	text str: data["id"], layout: "bottom_right"

	save_png prefix: "module_"
end
