TrackSegment = {
    wall_perp = {
        x = 1,
        y = 0,
        z = 1
    },
    wall_start = 5,
    wall_end = 10,
    path_start = -10,
    path_end = 10,
    corner_object = nil,

    OnStart = function(self)
        if TrackSegments == nil then
            TrackSegments = {}
        end
        TrackSegments[self.actor:GetID()] = self
        self.wall_perp = vec3.normalize(vec3(self.wall_perp.x, self.wall_perp.y, self.wall_perp.z))

        self.wall_dir = vec3.cross(self.wall_perp, vec3(0, 1, 0))
        if self.corner_object ~= nil then
            local object1 = Actor.Instantiate(self.corner_object)
            object1:GetComponent("Model").translation = vec3.add(vec3.mul(self.wall_perp, self.wall_start), vec3.mul(self.wall_dir, self.path_start))
            local object2 = Actor.Instantiate(self.corner_object)
            object2:GetComponent("Model").translation = vec3.add(vec3.mul(self.wall_perp, self.wall_start), vec3.mul(self.wall_dir, self.path_end))
            local object3 = Actor.Instantiate(self.corner_object)
            object3:GetComponent("Model").translation = vec3.add(vec3.mul(self.wall_perp, self.wall_end), vec3.mul(self.wall_dir, self.path_start))
            local object4 = Actor.Instantiate(self.corner_object)
            object4:GetComponent("Model").translation = vec3.add(vec3.mul(self.wall_perp, self.wall_end), vec3.mul(self.wall_dir, self.path_end))
        end
    end
}
