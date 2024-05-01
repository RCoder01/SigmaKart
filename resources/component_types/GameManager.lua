GameManager = {
	default_pos = Transform(
		vec3(80, 25, -75),
		vec3(2.4, -0.23, 0),
		vec3(1, 1, 1)),

	text_transform = Transform(
		vec3(78, 24.5, -73),
		vec3(0.83, 0, 0),
		vec3(1, 1, 1)),

	OnStart = function(self)
		Event.Subscribe("TrackCompleted", self, self.PlayerFinishCallback)
		self.state = "startup"
		self:CreateText("intro")
	end,

	CreateText = function(self, name)
		local actor = Actor.Instantiate(name)
		actor:GetComponent("Model").transform = self.text_transform
	end,

	OnUpdate = function(self)
		local delta = 0
		if Input.GetKey("up") then
			delta = delta + 0.01
		end
		if Input.GetKey("down") then
			delta = delta - 0.01
		end
		local follow = self.actor:GetComponent("Follow")
		follow.offset.rotation_pitch = follow.offset.rotation_pitch + delta

		if Input.GetKeyDown("enter") then
			Debug.Log("In state " .. self.state)
			if self.state == "startup" then
				Actor.Destroy(Actor.Find("text"))
				Actor.Instantiate("player")
				follow.enabled = true
				follow.target = "player"
				self.state = "player1"
				self.player_1_start = Application.GetFrame()
			end
			if self.state == "credits" then
				Actor.Destroy(Actor.Find("text"))
				self:CreateText("intro")
				self.state = "startup"
			end
			if self.state == "halfway" then
				Actor.Destroy(Actor.Find("text"))
				Actor.Instantiate("player")
				follow.enabled = true
				follow.target = "player"
				self.state = "player2"
				self.player_2_start = Application.GetFrame()
			end
			if self.state == "finished" then
				Actor.Destroy(Actor.Find("text"))
				self:CreateText("intro")
				self.state = "startup"
			end
		end

		if Input.GetKeyDown("c") and self.state == "startup" then
			Actor.Destroy(Actor.Find("text"))
			self:CreateText("credits")
			self.state = "credits"
		end

		if not follow.enabled then
			Camera.transform = self.default_pos
		end
	end,

	PlayerFinishCallback = function(self)
		local follow = self.actor:GetComponent("Follow")
		follow.enabled = false
		Actor.Destroy(Actor.Find("player"))
		if self.state == "player1" then
			self:CreateText("halfway")
			self.player_1_time = Application.GetFrame() - self.player_1_start
			Debug.Log("Player 1 finished in " .. self.player_1_time .. " frames")
			self.state = "halfway"
		end
		if self.state == "player2" then
			self.player_2_time = Application.GetFrame() - self.player_2_start
			Debug.Log("Player 2 finished in " .. self.player_2_time .. " frames")
			if self.player_1_time < self.player_2_time then
				self:CreateText("player1")
			else
				self:CreateText("player2")
			end
			self.state = "finished"
		end
	end
}
