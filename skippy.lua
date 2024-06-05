-- skippy-mpv
-- https://github.com/trytriangles/skippy-mpv
local skips = {}
local next_skip_index = 1

-- Split a string on a delimiter
local function split_string(inputstr, delimiter)
    local result = {}
    for match in (inputstr .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Get the contents of a file as a string, or nil if it's nonexistent
local function read_file(file_path)
    local file = io.open(file_path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

-- Convert an HH:MM:SS timestamp to a number of seconds.
local function timestamp_to_seconds(timestamp)
    local hours, minutes, seconds = timestamp:match("(%d+):(%d+):(%d+)")
    hours = tonumber(hours)
    minutes = tonumber(minutes)
    seconds = tonumber(seconds)

    if not hours or not minutes or not seconds then
        return nil
    end

    return hours * 3600 + minutes * 60 + seconds
end

-- Strip the file extension from a filename, being the portion after the last .
local function strip_extension(filename)
    local last_dot_index = filename:find("%.[^.]*$")
    if last_dot_index then
        return filename:sub(1, last_dot_index - 1)
    end
    return filename
end

-- Parse an EDL line into {start_timestamp, end_timestamp, int_flag}
local function parse_line(line)
    local words = split_string(line, " ")
    local start = timestamp_to_seconds(words[1])
    local finish = timestamp_to_seconds(words[2])
    local flag = string.sub(words[3], 1, 1)
    return {start, finish, flag}
end

local function on_time_pos_change(name, value)
    if value == nil then return end
    if value > skips[next_skip_index][1] then
        if skips[next_skip_index][1] <= value then return end
        mp.commandv('seek', skips[next_skip_index][2], "absolute")
        next_skip_index = next_skip_index + 1
        if next_skip_index > #skips then
            mp.unobserve_property(on_time_pos_change)
        end
    end
end

local function on_file_loaded(name, value)
    if value == nil then return end
    mp.unobserve_property(on_time_pos_change)
    local edl_path = strip_extension(value) .. ".edl"
    if value == edl_path then
        -- We're playing an EDL file, which cannot itself have a sidecar EDL.
        return
    end
    local file_content = read_file(edl_path)
    if file_content == nil then
        -- No EDL found, or file could not be read.
        return
    end
    local lines = split_string(file_content, "\n")
    for _, line in ipairs(lines) do
        if line == "" then break end
        table.insert(skips, parse_line(line))
    end
    next_skip_index = 1
    mp.observe_property("time-pos", "native", on_time_pos_change)
end

mp.observe_property("path", "string", on_file_loaded)
