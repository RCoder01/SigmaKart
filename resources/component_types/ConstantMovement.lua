ConstantMovement = {
    speed = 0.01,

	OnUpdate = function(self)
        local model = self.actor:GetComponent("Model")
        model.translation_z = model.translation_z + self.speed
	end
}
