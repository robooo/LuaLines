local methods = require "lualines.methods"

local filepath = "./spec/testing_file.gpx"

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
			
			local parsed_by_name = methods.single_parse("name", filepath)
			assert.are.same(parsed_by_name, result_table)
		end)
	end)

--multi parse
	describe('multi_parse', function()
		
		it('with basic usage \'name\' and \'Cintorin\'', function()
			local result_table = { "<name>Cintorinska</name>" }
			local input_table = { "name", "Cintorin" }

			local parsed_by_name = methods.multi_parse(input_table, filepath)
			assert.are.same(parsed_by_name, result_table)
		end)
	end)


--multi parse
	describe('inner_parse', function()
		
		it('with basic usage one pattern', function()
			local result_table = { "<wpt lat=\"48.1938643\" lon=\"17.2649011\">",
				"<extensions>",
				"<ogr:osm_id>768508</ogr:osm_id>",
				"<ogr:other_tags>&quot;railway&quot;=&gt;&quot;level_crossing&quot;</ogr:other_tags>",
				"</extensions>",
				"</wpt>"
			}

			local first_tag = "<wpt"
			local last_tag = "</wpt>"
			local patterns = {"railway"}

			local parsed_by_name = methods.inner_parse(first_tag, last_tag, patterns, filepath)
			assert.are.same(parsed_by_name, result_table)
		end)

		it('with basic usage two patterns', function()
			local result_table ={ "<wpt lat=\"47.8707791\" lon=\"16.6480066\">", "<extensions>",
				"<ogr:osm_id>448136</ogr:osm_id>", "<ogr:highway>traffic_signals</ogr:highway>",
				"<ogr:other_tags>&quot;traffic_signals:direction&quot;=&gt;&quot;backward&quot;</ogr:other_tags>",
				"</extensions>", "</wpt>", "<wpt lat=\"47.9576349\" lon=\"16.787799\">", "<name>Jois</name>",
				"<extensions>", "<ogr:osm_id>538174</ogr:osm_id>",
				"<ogr:other_tags>&quot;traffic_sign&quot;=&gt;&quot;city_limit&quot;</ogr:other_tags>",
				"</extensions>", "</wpt>", "<wpt lat=\"48.177734\" lon=\"17.1675552\">", "<extensions>",
				"<ogr:osm_id>1052637</ogr:osm_id>", "<ogr:highway>crossing</ogr:highway>",
				"<ogr:other_tags>&quot;crossing&quot;=&gt;&quot;traffic_signals&quot;</ogr:other_tags>",
				"</extensions>", "</wpt>", "<wpt lat=\"48.1773219\" lon=\"17.167633\">", "<extensions>",
				"<ogr:osm_id>1052638</ogr:osm_id>", "<ogr:highway>traffic_signals</ogr:highway>", "</extensions>", "</wpt>"
			}

			local first_tag = "<wpt"
			local last_tag = "</wpt>"
			local patterns = {"traff", "ogr"}

			local parsed_by_name = methods.inner_parse(first_tag, last_tag, patterns, filepath)
			assert.are.same(parsed_by_name, result_table)
		end)
	end)

end)