Transformer = {
    time = 100,

    OnUpdate = function(self)
        local model = self.actor:GetComponent("Model")
        local transform = model.transform
        if Application.GetFrame() == 60 then
            model.mesh = "pyramid.gltf"
            transform.scale = vec3(300, 300, 300)
        end
        model.transform = transform
    end
}