StaticPhysics = {
    OnStart = function(self)
        if StaticColliders == nil then
            StaticColliders = {}
        end
        StaticColliders[self.actor:GetID()] = self
    end
}