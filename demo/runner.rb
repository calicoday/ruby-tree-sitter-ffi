# Runner class with methods for node_walk.rb, tree_cursor_walk.rb

module Runner
	module_function
	
	def parse(lang, str)
		lang = TreeSitterFFI.send("parser_#{lang}")
		pars = TreeSitterFFI.parser
		pars.set_language(lang)
		tree = pars.parse(str)
	end

	# walk the syntax tree and compose each node
	def compose_via_node(node, input, &b)
		s = ""
		offset = 0
		visit_before(node) do |n, depth|
			node_s, offset = compose_node(n, depth, input, offset, &b)
			s += node_s
		end
		s
	end
	
	# depth-first Node walk, yielding before descending further
	def visit_before(node, depth=0, &b)
		yield node, depth
		node.child_count.times.each do |i|	
			visit_before(node.child(i), depth + 1, &b)
		end
	end

	def compose_via_tree_cursor(node, input, &b)
		s = ""
		offset = 0
		curs = TreeSitterFFI.tree_cursor(node)		
		goto_before(curs) do |n, depth|
			node_s, offset = compose_node(n, depth, input, offset, &b)
			s += node_s
		end
		s
	end

	# depth-first TreeCursor walk, yielding before descending further
	def goto_before(curs, depth=0, &b)
		yield curs.current_node, depth
		return unless curs.goto_first_child
		goto_before(curs, depth + 1, &b)
		while(curs.goto_next_sibling)
			goto_before(curs, depth + 1, &b)
		end
		curs.goto_parent
	end
	
	# If no block is supplied, put out the original whitespace and text from the input.
	# Otherwise, yield with the whitespace and text from the input and return a 
	# string to output or nil for only the original text, no whitespace.
	def compose_node(n, depth, input, offset, &b)
		return ['', offset] unless n.child_count == 0
		# text chunk from the input
		text = input[n.start_byte...n.end_byte]
		# whitespace chunk from the input since the previous text chunk or start
		ws = input[offset...n.start_byte]
		output = ws + text
		# yield for preferred output string, if block_given?
		output = yield(n, depth, ws, text) || text if block_given?
		[output, n.end_byte]
	end

	# pretty-print the syntax tree and input text chunks
	def pretty_node(node, input, edge='<>'.chars)
		s = ""
		visit_before(node) do |n, depth|
			# indent for current tree depth, \n if not the root
			newline = (n != node ? "\n" : '')
			s += "#{newline}#{'  '* depth}"
			# grammar production, with specified edge markers
			s += "#{edge[0]}#{n.type}#{edge[1]}"
			if n.child_count == 0
				# text chunk from the input
				s += "\n#{'  '* (depth+1)}#{input[n.start_byte...n.end_byte]}" 
			end
		end
		s
	end
	
	# pretty-print s-expression from Node#string
	def pretty_sexp_from_string(sexp)
		depth = 0
		arr = sexp.split(/([()])/)
		s = ""
		on_delims(arr, ['('], [')']) do |frag, key, first|
			# \n if not the first chunk
			newline = (first ? '' : "\n")
			case key
			when :open then s += "#{newline}#{'  '* depth}"; depth += 1
			when :close then depth -= 1
			end
			s += frag
		end
		s += "\n"
	end

	def on_delims(arr, open, close, match=false, &b)
		seek = ''
		# pass true if first frag
		first = true
		# advance one if there's nothing before the first delim
		arr.shift if arr[0] == ""
		while frag = arr.shift do
			if close.include?(frag) && (match ? frag == seek : true)
				yield(frag, :close, first)
			elsif open.include?(frag)
				seek = close[open.index(frag)]
				yield(frag, :open, first)
			else
				yield(frag, :else, first)
			end
			first = false
		end
	end

end
