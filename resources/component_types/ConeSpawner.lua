ConeSpawner = {
    cones = {
        vec3(33.14, -0.36, 14.4),
        vec3(35.197547912598, -0.36000001430511, 17.089326858521),
        vec3(15.112309455872, -0.36000001430511, -13.573480606079),
        vec3(14.778175354004, -0.36000001430511, -12.856935501099),
        vec3(14.534853935242, -0.36000001430511, -12.298421859741),
        vec3(14.270687103271, -0.36000001430511, -11.7262840271),
        vec3(14.002099990845, -0.36000001430511, -11.151743888855),
        vec3(13.735863685608, -0.36000001430511, -10.590050697327),
    },

    OnStart = function(self)
        for i, cone in ipairs(self.cones) do
            local object = Actor.Instantiate("cone")
            object:GetComponent("Model").translation = cone
        end
    end,
}
