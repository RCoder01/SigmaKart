ObjectSpawner = {
    object = nil,
    scale = 1,

    OnUpdate = function (self)
        if Input.GetKeyDown("delete") then
            if self.last_spawned ~= nil then
                Actor.Destroy(self.last_spawned)
                self.last_spawned = nil
            end
        end
        if Input.GetKeyDown("space") then
            local object = Actor.Instantiate(self.object)
            object:GetComponent("Model").translation = self.actor:GetComponent("Model").transform.translation
            local translation = object:GetComponent("Model").transform.translation
            Debug.Log("Object spawned at " .. translation.x .. ", " .. translation.y .. ", " .. translation.z)
            self.last_spawned = object
        end
    end
}
