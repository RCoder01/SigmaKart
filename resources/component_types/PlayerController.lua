PlayerController = {
    radius = 0.5,
    linear_acceleration = 0.01,
    angular_acceleration = 0.01,
    drag_coef = 0.01,
    vel = vec3(0, 0, 0),
    dir = vec3(1, 0, 0),
    speed = 0,
    is_reverse = false,

    OnStart = function(self)
        if TrackSegments == nil then
            TrackSegments = {}
        end
        if StaticColliders == nil then
            StaticColliders = {}
        end
    end,

    OnUpdate = function(self)
        -- if Input.GetKeyDown("p") then
        --     Debug.Log(self.actor:GetComponent("Model").transform:tostring())
        -- end
        local acc = self:GetInputAcceleration()

        local old_yaw = math.atan(self.dir.z, self.dir.x)
        local new_yaw = old_yaw + acc.z
        local new_dir =  vec3(math.cos(new_yaw), 0, math.sin(new_yaw))
        local similarity = math.max(vec3.dot(new_dir, self.dir), 0)
        if vec3.magnitude(self.vel) < 0.00001 then
            similarity = 1
        end
        local new_speed = self.speed * similarity + acc.x
        new_speed = new_speed * (1 - self.drag_coef)
        self.vel = vec3.mul(new_dir, new_speed)
        self.speed = new_speed
        self.dir = new_dir

        local model = self.actor:GetComponent("Model")
        model.translation = vec3.add(model.translation, self.vel)
        -- Debug.Log("Velocity: " .. self.vel.x .. ", " .. self.vel.y .. ", " .. self.vel.z)
        if vec3.magnitude(self.dir) > 0.00001 then
            model.rotation_yaw = math.atan(self.dir.z, self.dir.x)
        end

        for id, collider in pairs(StaticColliders) do
            local this_model = self.actor:GetComponent("Model")
            local this_translation = this_model.translation
            local this_radius = self.radius
            local that_model = collider.actor:GetComponent("Model")
            local that_translation = that_model.translation
            local that_radius = collider.radius
            local diff = vec3.sub(this_translation, that_translation)
            local dist = vec3.magnitude(diff)
            if dist < this_radius + that_radius then
                local overlap = (this_radius + that_radius - dist) / 2
                local correction = vec3.mul(vec3.normalize(diff), overlap)
                this_model.translation = vec3.add(this_translation, correction)

                self.speed = self.speed + vec3.dot(correction, self.dir)
            end
        end

        self:TrackPhysics()
    end,

    GetInputAcceleration = function(self)
		local acc = vec3(0, 0, 0)
        if Input.GetKey("w") then
            acc.x = acc.x + 1
        end
        if Input.GetKey("s") then
			acc.x = acc.x - 1
		end
		if Input.GetKey("a") then
			acc.z = acc.z - 1
		end
		if Input.GetKey("d") then
			acc.z = acc.z + 1
		end
		-- if Input.GetKey("q") then
		-- 	acc.y = acc.y - 1
		-- end
		-- if Input.GetKey("e") then
		-- 	acc.y = acc.y + 1
		-- end

		acc.x = acc.x * self.linear_acceleration
        acc.z = acc.z * self.angular_acceleration
        return acc
    end,

    TrackPhysics = function (self)
        local min_error = nil
        local min_correction = vec3(0, 0, 0)
        local nearest = nil
        local this_model = self.actor:GetComponent("Model")
        local this_translation = this_model.translation
        for id, segment in pairs(TrackSegments) do
            local proj = vec3.dot(this_translation, segment.wall_perp)
            local rej = vec3.dot(this_translation, segment.wall_dir)
            local wall_min = math.min(segment.wall_start, segment.wall_end) + self.radius
            local short = proj < wall_min
            local wall_max = math.max(segment.wall_start, segment.wall_end) - self.radius
            local long = proj > wall_max
            local path_min = math.min(segment.path_start, segment.path_end) + self.radius
            local near = rej < path_min
            local path_max = math.max(segment.path_start, segment.path_end) - self.radius
            local far = rej > path_max
            if not short and not long and not near and not far then
                min_error = nil
                Event.Publish("InTrackSegment", segment.actor:GetID())
                break
            end
            if short or long or near or far then
                local error = vec2(0, 0)
                local correction = vec3(0, 0, 0)
                if short then
                    error.x = wall_min - proj
                    correction = vec3.add(correction, vec3.mul(segment.wall_perp, error.x))
                end
                if long then
                    error.x = wall_max - proj
                    correction = vec3.add(correction, vec3.mul(segment.wall_perp, error.x))
                end
                if near then
                    error.y = path_min - rej
                    correction = vec3.add(correction, vec3.mul(segment.wall_dir, error.y))
                end
                if far then
                    error.y = path_max - rej
                    correction = vec3.add(correction, vec3.mul(segment.wall_dir, error.y))
                end
                if short and long then
                    Debug.Log("Short and long!")
                end
                if near and far then
                    Debug.Log("Near and far!")
                end
                if min_error == nil or vec2.magnitude(error) < min_error then
                    min_error = vec2.magnitude(error)
                    min_correction = correction
                    nearest = segment.actor:GetID()
                end
            end
            this_model.translation = this_translation
        end
        if min_error ~= nil then
            this_model.translation = vec3.add(this_model.translation, min_correction)
            self.speed = self.speed + vec3.dot(min_correction, self.dir)
            Event.Publish("InTrackSegment", nearest)
        end
    end,

    TrackDebug = function (self)
        for id, segment in pairs(TrackSegments) do
            local this_model = self.actor:GetComponent("Model")
            local this_translation = this_model.translation
            local track_dir = segment.wall_perp
            local proj = vec3.dot(this_translation, track_dir)
            local rej = vec3.dot(this_translation, segment.wall_dir)
            if Input.GetKeyDown("p") then
                Debug.Log(segment.actor:GetName())
                Debug.Log("Proj: " .. proj)
                Debug.Log("Rej: " .. rej)
            end
        end
    end
}
