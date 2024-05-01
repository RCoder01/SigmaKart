Follow = {
	target = nil,
    is_camera = false,
    offset = Transform.identity(),
    ease_factor = 1,
    mode = "compose",

    OnStart = function(self)
		if self.target ~= nil then
			self.target = Actor.Find(self.target):GetComponent("Model")
		end
        self.offset = Transform(
            vec3(
                self.offset.translation_x,
                self.offset.translation_y,
                self.offset.translation_z),
            vec3(
                self.offset.rotation_yaw,
                self.offset.rotation_pitch,
                self.offset.rotation_roll),
            vec3(1, 1, 1))
    end,

    OnUpdate = function(self)
        if self.target == nil then
            return
        end
        if type(self.target) == "string" then
            self:OnStart()
        end
        local old_transform = Camera.transform
        if not self.is_camera then
            old_transform = self.actor:GetComponent("Model").transform
        end
        local new_transform = Transform.identity()
        new_transform.translation = Math.Rotate(self.offset.translation, self.target.transform.rotation)
        new_transform.translation = vec3.add(new_transform.translation, self.target.transform.translation)
        if self.mode == "compose" then
            new_transform.rotation = Math.RotationCompose(self.target.transform.rotation, self.offset.rotation)
        elseif self.mode == "add" then
            new_transform.rotation = vec3.add(self.target.transform.rotation, self.offset.rotation)
        end
        -- new_transform.scale = vec3(
        --     self.offset.scale.x * self.target.transform.scale.x,
        --     self.offset.scale.y * self.target.transform.scale.y,
        --     self.offset.scale.z * self.target.transform.scale.z)

        local yaw_correction = 0
        while (new_transform.rotation.yaw - old_transform.rotation.yaw) > math.pi do
            new_transform.rotation.yaw = new_transform.rotation.yaw - 2 * math.pi
            yaw_correction = yaw_correction + 2 * math.pi
        end
        while (new_transform.rotation.yaw - old_transform.rotation.yaw) < -math.pi do
            new_transform.rotation.yaw = new_transform.rotation.yaw + 2 * math.pi
            yaw_correction = yaw_correction - 2 * math.pi
        end
        local eased = old_transform:mul(1 - self.ease_factor):add(new_transform:mul(self.ease_factor))
        eased.rotation.yaw = eased.rotation.yaw + yaw_correction

        if self.is_camera then
            eased.scale = Camera.transform.scale
            Camera.transform = eased
        else
            eased.scale = self.actor:GetComponent("Model").scale
            self.actor:GetComponent("Model").transform = eased
        end
    end
}
