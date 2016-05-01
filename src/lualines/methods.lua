-- FIND function based on SINGLE PATTERN 
local function single_parse (s_key, filepath)
	local final_parse = {}

	for line in io.lines(filepath) do
		if string.match(line, s_key) ~= nil then
			final_parse[#final_parse + 1] = line:gsub("^%s*", "")
		end
	end

	return final_parse
end

-- FIND function based on MORE PATTERNS
local function multi_parse (patterns, filepath)
	local final_parse = {}
	local parsed = {}
	local num_found = 1

	for line in io.lines(filepath) do
		if string.match(line, patterns[#patterns]) ~= nil then
			while #patterns - num_found ~= 0 do
				if string.match(line, patterns[#patterns - num_found]) ~= nil then
					num_found = num_found + 1
				else
					break
				end

				if num_found == #patterns then
					parsed[#parsed + 1] = line:gsub("^%s*", "")
				end
			end
			num_found = 1
		end
	end

	for _,v in ipairs(parsed) do 
		final_parse[#final_parse+1] = v
	end
	
	return final_parse
end

-- if it finds "start tag", next step is to find all patterns in paragraph till "ending tag"
-- paragraph is parsed just in case there are all patterns between tags
-- if there is no pattern to find (= 0) inside tags, all text inside in paragraph parsed  
local function inner_parse (first_tag, last_tag, patterns, filepath)
	local final_parse = {}
	local parsed = {}
	local tag_found = 0
	local patterns_found = 0
	local all_found = 0
	local temp_patterns = {}

	for line in io.lines(filepath) do
		
		if string.match(line, first_tag) ~= nil then 	-- first tag found, create temporary table with patterns
			tag_found = 1
			for i,_ in ipairs(patterns) do
				temp_patterns[i] = patterns[i]
			end
		end
		
		if tag_found == 1 then
			parsed[#parsed + 1] = line:gsub("^%s*", "")

			if #patterns - patterns_found ~= 0 then
				for index, value in pairs (temp_patterns) do
					if string.match(line, value) ~= nil and all_found == 0 then
						temp_patterns[index] = nil 
						patterns_found = patterns_found + 1
    			end
				end

				if #patterns == patterns_found then
					all_found = 1
				end

			end
		end

		if #patterns == patterns_found then 	-- if patterns = 0, set all_found = 1 to continue
			all_found = 1
		end

		if string.match(line, last_tag) ~= nil and all_found == 1 then
			for _,v in ipairs(parsed) do 
				final_parse[#final_parse+1] = v
			end
			all_found = 0
			patterns_found = 0
			parsed = {}
			tag_found = 0
		elseif string.match(line, last_tag) ~= nil and all_found == 0 then
			all_found = 0
			patterns_found = 0
			parsed = {}
			tag_found = 0
		end
	end
	return final_parse
end

return {
	single_parse = single_parse,
	multi_parse = multi_parse,
	inner_parse = inner_parse
}
