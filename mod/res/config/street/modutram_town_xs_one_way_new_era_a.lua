function data()
return {
	laneConfig = {
		{ forward = true },
		{ forward = true },
		{ forward = true },
	},
	streetWidth = 3.0,
	sidewalkWidth = 1.0,
	sidewalkHeight = .00,
	yearFrom = 1925,
	yearTo = 0,
	upgrade = false,
	country = false,
	speed = 30.0,
	type = "one way new small",
	name = _("Small one-way street"),
	desc = _("One-lane one-way street with modern catenary poles (speed limit %2%)."),
	icon = "ui/streets/standard/country_small_one_way_new.tga",
	categories = { "one-way" },
	borderGroundTex = "street_border.lua",
	materials = {
		streetPaving = {
			name = "street/old_small_paving.mtl",
			size = {12.0,12.0}
		},		
		streetBorder = {
			-- name = "street/old_medium_border.mtl",
			-- size = {8,0.8}
		},			
		streetLane = {
			name = "street/old_small_lane.mtl",
			size = { 12.0, 3.0 }
		},
		streetStripe = {
			
		},
		streetStripeMedian = {
		},
		streetTram = {
			name = "street/old_medium_tram_paving.mtl",
			size = { 2.0, 2.0 }
		},
		streetTramTrack = {
			name = "street/old_medium_tram_track.mtl",
			size = { 2.0, 2.0 }
		},
		streetBus = {
		},
		crossingLane = {
			name = "street/old_small_lane.mtl",
			size = { 12.0, 2.5 }
		},
		crossingBus = {
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
		},
		sidewalkPaving = {
			name = "street/old_small_paving.mtl",
			size = {12.0,12.0}
		},
		sidewalkLane = {	

		},
		sidewalkBorderInner = {
			-- name = "street/old_medium_sidewalk_border_inner.mtl",
			-- size = { 8.0, 1.2 }
		},
		sidewalkBorderOuter = {
			name = "street/old_medium_sidewalk_border_outer.mtl",
			size = { 3.0, 0.6 }
		},
		sidewalkCurb = {
			-- name = "street/old_medium_sidewalk_curb.mtl",
			-- size = {8.0,.3}
		},
		sidewalkWall = {
			-- name = "street/old_medium_sidewalk_wall.mtl",
			-- size = {.3,.3}
		}		
	},
	assets = {	},
	catenary = {
		pole = {
			name = "asset/modutram_catenary_pole_era_a.mdl",
			assets = { }  
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
