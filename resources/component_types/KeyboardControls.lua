KeyboardControls = {
    OnUpdate = function(self)
        local model = self.actor:GetComponent("Model")
		local move = vec3(0, 0, 0)
        if Input.GetKey("s") then
			move.x = move.x - 1
		end
		if Input.GetKey("w") then
			move.x = move.x + 1
		end
		if Input.GetKey("a") then
			move.z = move.z - 1
		end
		if Input.GetKey("d") then
			move.z = move.z + 1
		end
		if Input.GetKey("q") then
			move.y = move.y - 1
		end
		if Input.GetKey("e") then
			move.y = move.y + 1
		end
		move = vec3.mul(vec3.normalize(move), 0.1)
		if Input.GetKey("lshift") then
			move = vec3.mul(move, 0.1)
		end
		if Input.GetKey("lctrl") then
			move = vec3.mul(move, 5)
		end
		model.translation = vec3.add(model.translation, Math.Rotate(move, model.rotation))
		local rotate = vec3(0, 0, 0)
		if Input.GetKey("left") then
			rotate.x = rotate.x - 0.1
		end
		if Input.GetKey("right") then
			rotate.x = rotate.x + 0.1
		end
		if Input.GetKey("lshift") then
			rotate = vec3.mul(rotate, 0.1)
		end
		model.rotation = vec3.add(model.rotation, rotate)
    end
}
