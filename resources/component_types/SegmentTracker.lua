SegmentTracker = {
    SegmentCallback = function(self, segment)
        if self.segments[segment] == false then
            self.segments[segment] = true
            Debug.Log("Segment " .. segment .. " entered")

            for id, segment in pairs(self.segments) do
                if segment == false then
                    return
                end
            end
            Debug.Log("All segments entered")
        end
    end,

    OnStart = function(self)
        self.segments = {}
        for id, segment in pairs(TrackSegments) do
            self.segments[id] = false
        end
        Event.Subscribe("InTrackSegment", self, self.SegmentCallback)
    end,

    OnUpdate = function(self)
        for id, segment in pairs(self.segments) do
            if segment == false then
                return
            end
        end
        local player = Actor.Find("player")
        local player_transform = player:GetComponent("Model").transform
        if math.abs(player_transform.translation.x) < 2 and player_transform.translation.z > 0 then
            Debug.Log("Player has completed the track")
            Event.Publish("TrackCompleted", nil)
        end
    end,

    OnDestroy = function(self)
        Event.Unsubscribe("InTrackSegment", self, self.SegmentCallback)
    end
}
