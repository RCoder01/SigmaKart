MouseControls = {
	last_mouse_pos = nil,

    OnUpdate = function(self)
        local model = self.actor:GetComponent("Model")
        local transform = model.transform
		if not Input.GetMouseButton(1) then
			self.last_mouse_pos = Input.GetMousePosition()
			return
		end
        if self.last_mouse_pos == nil then
			return
		end
		local mouse_pos = Input.GetMousePosition()
		local delta = vec2(
			mouse_pos.x - self.last_mouse_pos.x,
			mouse_pos.y - self.last_mouse_pos.y)
		transform.rotation_yaw = transform.rotation_yaw + delta.x * 0.01
		transform.rotation_pitch = transform.rotation_pitch - delta.y * 0.01
		self.last_mouse_pos = Input.GetMousePosition()
		model.transform = transform
    end
}
