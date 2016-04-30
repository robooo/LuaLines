local methods = require "lualines.methods"

arg[#arg] = "./spec/testing_file.gpx"	-- TODO change for nice filepath not arg[#arg]

---
--BASIC TESTS
describe( 'basic test', function()
	it('if all methods are returned', function()
		assert.is.not_false(methods.single_parse)
		assert.is.not_false(methods.multi_parse)
		assert.is.not_false(methods.inner_parse)
	end)
end)

---
--METHOD TESTS
describe( 'testing methods', function()

--single parse
	describe('single_parse', function()
    
    it('with basic usage \'name\'', function()
    	local result_table = {"<name>Jois</name>",
				"<name>Zimny stadion</name>",
				"<name>Cintorinska</name>",
				"<name>Holleho</name>",
				"<name>Dlha</name>",
				"<name>Imelska</name>"
			}
    	
    	local parsed_by_name = methods.single_parse("name")
    	assert.are.same(parsed_by_name, result_table)
    end)
  end)

--multi parse
  describe('multi_parse', function()
    
    it('with basic usage \'name\' and \'Cintorin\'', function()
    	local result_table = { "<name>Cintorinska</name>" }
    	local input_table = { "name", "Cintorin" }

    	local parsed_by_name = methods.multi_parse(input_table)
    	assert.are.same(parsed_by_name, result_table)
    end)
  end)

end)