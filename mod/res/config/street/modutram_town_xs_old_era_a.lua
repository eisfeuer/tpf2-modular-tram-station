function data()
return {
	numLanes = 2,
	streetWidth = 6.0,
	sidewalkWidth = 1.0,
	sidewalkHeight = .00,
	yearFrom = 1925,
	yearTo = 0,
	upgrade = false,
	country = false,
	speed = 30.0,
	type = "new small",
	name = _("Small street"),
	desc = _("Old Two-lane street with old catenary poles (speed limit %2%)."),
	categories = { "urban" },
	borderGroundTex = "street_border.lua",
	materials = {
		streetPaving = {
			name = "street/old_medium_sidewalk.mtl",
			size = { 6.0, 6.0 }
		},		
		--streetBorder = {
			--name = "street/new_small_border.mtl",
			--size = { 1.5, 0.625 }
		
		--},			
		streetLane = {

		},
		streetStripe = {

		},
		streetStripeMedian = {

		},
		streetBus = {
			name = "street/new_medium_bus.mtl",
			size = { 12, 2.7 }
		},
		streetTram = {
			name = "street/old_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		streetTramTrack = {
			name = "street/old_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		crossingLane = {
			name = "street/old_small_lane.mtl",
			size = { 4.0, 4.0 }
		},
		crossingBus = {
			name = ""		
		},
		crossingTram = {
			name = "street/old_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		crossingTramTrack = {
			name = "street/old_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		crossingCrosswalk = {
			name = ""		
		},
		sidewalkPaving = {
			name = "street/old_medium_sidewalk.mtl",
			size = { 6.0, 6.0 }
		},
		sidewalkLane = {	

		},
		sidewalkBorderOuter = {
			name = "street/old_medium_sidewalk_border_outer.mtl",		
			size = { 16.0, 0.3 }
		},
		sidewalkCurb = {
			name = "street/old_medium_sidewalk_curb.mtl",
			size = { 3, .3 }
		},
		sidewalkWall = {
			name = "street/old_medium_sidewalk_wall.mtl",
			size = { .3, .3 }
		},
		catenary = {
			name = "street/tram_cable.mtl"
		}
	},
	assets = { },
	catenary = {
		pole = {
			name = "asset/modutram_catenary_pole_era_a.mdl",
			assets = {}  
		},
		poleCrossbar = {
			name = "asset/tram_pole_crossbar.mdl",
			assets = { "asset/tram_pole_light.mdl" }  
		},
		poleDoubleCrossbar = {
			name = "asset/tram_pole_double_crossbar.mdl",
			assets = { "asset/tram_pole_light.mdl" }  
		},
		isolatorStraight = "asset/cable_isolator.mdl",
		isolatorCurve = "asset/cable_isolator.mdl",
		junction = "asset/cable_junction.mdl"
	},
	signalAssetName = "asset/ampel.mdl",
	cost = 20.0,
}
end
