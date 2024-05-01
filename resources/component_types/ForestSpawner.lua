ForestSpawner = {
    min_x = -10,
    max_x = 10,
    min_z = -10,
    max_z = 10,

	OnStart = function(self)
        for i = self.min_x, self.max_x do
            for j = self.min_z, self.max_z do
                local new_actor = Actor.Instantiate("tree")
                new_actor:GetComponent("Model").translation = vec3(i + Math.Random(-1, 1), 0, j + Math.Random(-1, 1))
            end
        end
	end,
}
