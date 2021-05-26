diff -r -x'.*' ./gen/sigs-keep/node_spec.rb ./gen/sigs/node_spec.rb
93a94,99
> 	it "field_name_for_child(Integer) # => String" do
> 		ret = node_0.field_name_for_child(arg_1)
> 		ret.should_not == nil
> 		ret.is_a?(String).should == true
> 	end
> 
diff -r -x'.*' ./gen/sigs-keep/query_spec.rb ./gen/sigs/query_spec.rb
76a77,87
> 	it "match_limit() # => Integer" do
> 		ret = query_cursor_0.match_limit()
> 		ret.should_not == nil
> 		ret.is_a?(Integer).should == true
> 	end
> 
> 	it "set_match_limit(Integer) # => :bool" do
> 		ret = query_cursor_0.set_match_limit(arg_1)
> 		[true, false].include?(ret).should == true
> 	end
> 
diff -r -x'.*' ./gen/sigs-keep/tree_spec.rb ./gen/sigs/tree_spec.rb
55c55
< 	it "current_field_name() # => Array" do
---
> 	it "current_field_name() # => String" do
58c58
< 		ret.is_a?(Array).should == true
---
> 		ret.is_a?(String).should == true
87a88,93
> 	it "goto_first_child_for_point(Point) # => Integer" do
> 		ret = tree_cursor_0.goto_first_child_for_point(arg_1)
> 		ret.should_not == nil
> 		ret.is_a?(Integer).should == true
> 	end
> 
diff -r -x'.*' ./gen/sigs-keep/ts_node_spec.rb ./gen/sigs/ts_node_spec.rb
93a94,99
> 	it ":ts_node_field_name_for_child, [Node.by_value, :uint32], :string" do
> 		ret = TreeSitterFFI.ts_node_field_name_for_child(node_0, arg_1)
> 		ret.should_not == nil
> 		ret.is_a?(String).should == true
> 	end
> 
166c172
< 	it ":ts_node_descendant_for_point_range, [Node.by_value, Point, Point], Node.by_value" do
---
> 	it ":ts_node_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value" do
178c184
< 	it ":ts_node_named_descendant_for_point_range, [Node.by_value, Point, Point], Node.by_value" do
---
> 	it ":ts_node_named_descendant_for_point_range, [Node.by_value, Point.by_value, Point.by_value], Node.by_value" do
diff -r -x'.*' ./gen/sigs-keep/ts_query_spec.rb ./gen/sigs/ts_query_spec.rb
76a77,87
> 	it ":ts_query_cursor_match_limit, [QueryCursor], :uint32" do
> 		ret = TreeSitterFFI.ts_query_cursor_match_limit(query_cursor_0)
> 		ret.should_not == nil
> 		ret.is_a?(Integer).should == true
> 	end
> 
> 	it ":ts_query_cursor_set_match_limit, [QueryCursor, :uint32], :bool" do
> 		ret = TreeSitterFFI.ts_query_cursor_set_match_limit(query_cursor_0, arg_1)
> 		[true, false].include?(ret).should == true
> 	end
> 
diff -r -x'.*' ./gen/sigs-keep/ts_tree_spec.rb ./gen/sigs/ts_tree_spec.rb
55c55
< 	it ":ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :strptr" do
---
> 	it ":ts_tree_cursor_current_field_name, [TreeCursor.by_ref], :string" do
58c58
< 		ret.is_a?(Array).should == true
---
> 		ret.is_a?(String).should == true
87a88,93
> 	it ":ts_tree_cursor_goto_first_child_for_point, [TreeCursor.by_ref, Point.by_value], :int64" do
> 		ret = TreeSitterFFI.ts_tree_cursor_goto_first_child_for_point(tree_cursor_0, arg_1)
> 		ret.should_not == nil
> 		ret.is_a?(Integer).should == true
> 	end
> 
