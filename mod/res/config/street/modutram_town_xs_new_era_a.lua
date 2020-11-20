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
	desc = _("Two-lane street with modern catenary poles (speed limit %2%)."),
	icon = "ui/streets/standard/country_small_new.tga",
	categories = { "urban" },
	borderGroundTex = "street_border.lua",
	materials = {
		streetPaving = {
			name = "street/old_small_paving.mtl",
			size = {12.0,12.0}
		},		
		streetBorder = {

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

		},
		sidewalkBorderOuter = {
			name = "street/old_medium_sidewalk_border_outer.mtl",
			size = { 3.0, 0.6 }
		},
		sidewalkCurb = {

		},
		sidewalkWall = {

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
