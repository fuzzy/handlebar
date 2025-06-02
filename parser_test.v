module parser

import token_stream

fn tokenize_expr(expr string) !token_stream.TokenStream {
	streams := token_stream.new_token_stream_from_string(expr)
	if streams.len > 0 {
		// println('PARSER_TEST DOOBIES: ${streams[0]}')
		return streams[0]
	}
	return error('no token stream found for expression')
}

fn test_parse_integer_literal() {
	mut p := new_parser(tokenize_expr('{{42}}')!)
	node := p.parse()!
	assert node is IntNode
	assert (node as IntNode).value == 42
}

fn test_parse_float_literal() {
	mut p := new_parser(tokenize_expr('{{42.0}}')!)
	node := p.parse()!
	assert node is FloatNode
	assert (node as FloatNode).value == 42.0
}

fn test_parse_addition_expr() {
	mut p := new_parser(tokenize_expr('{{1 + 2}}')!)
	node := p.parse()!
	assert node is BinaryNode
	bin := node as BinaryNode
	assert bin.left is IntNode
	assert (bin.left as IntNode).value == 1
	assert bin.op.symbol == '+'
	assert bin.right is IntNode
	assert (bin.right as IntNode).value == 2
}

fn test_parse_subtraction_expr() {
	mut p := new_parser(tokenize_expr('{{2 - 1}}')!)
	node := p.parse()!
	assert node is BinaryNode
	bin := node as BinaryNode
	assert bin.left is IntNode
	assert (bin.left as IntNode).value == 2
	assert bin.op.symbol == '-'
	assert bin.right is IntNode
	assert (bin.right as IntNode).value == 1
}

fn test_parse_multiplication_expr() {
	mut p := new_parser(tokenize_expr('{{1 * 2}}')!)
	node := p.parse()!
	assert node is BinaryNode
	bin := node as BinaryNode
	assert bin.left is IntNode
	assert (bin.left as IntNode).value == 1
	assert bin.op.symbol == '*'
	assert bin.right is IntNode
	assert (bin.right as IntNode).value == 2
}

fn test_parse_division_expr() {
	mut p := new_parser(tokenize_expr('{{2 / 1}}')!)
	node := p.parse()!
	assert node is BinaryNode
	bin := node as BinaryNode
	assert bin.left is IntNode
	assert (bin.left as IntNode).value == 2
	assert bin.op.symbol == '/'
	assert bin.right is IntNode
	assert (bin.right as IntNode).value == 1
}

fn test_parse_remainder_expr() {
	mut p := new_parser(tokenize_expr('{{7%2.23}}')!)
	node := p.parse()!
	assert node is BinaryNode
	bin := node as BinaryNode
	assert bin.left is IntNode
	assert (bin.left as IntNode).value == 7
	assert bin.op.symbol == '%'
	assert bin.right is FloatNode
	assert (bin.right as FloatNode).value == 2.23
}

fn test_parse_assign() {
	mut p := new_parser(tokenize_expr('{{varname = 2.23}}')!)
	node := p.parse()!
	assert node is AssignNode
	assign := node as AssignNode
	assert assign.left.name == 'varname'
	assert assign.right is FloatNode
	assert (assign.right as FloatNode).value == 2.23
}

fn test_parse_ident() {
	mut p := new_parser(tokenize_expr('{{myVar}}')!)
	node := p.parse()!
	assert node is IdentNode
	ident := node as IdentNode
	assert ident.name == 'myVar'
}

fn test_parse_nested_expr() {
	mut p := new_parser(tokenize_expr('{{(1 * 234) + (56 + 78)}}')!)
	node := p.parse()!
	assert node is BinaryNode
	bin := node as BinaryNode
	assert bin.op.symbol == '+'
	assert bin.left is BinaryNode
	left_bin := bin.left as BinaryNode
	assert left_bin.op.symbol == '*'
	assert left_bin.left is IntNode
	assert (left_bin.left as IntNode).value == 1
	assert left_bin.right is IntNode
	assert (left_bin.right as IntNode).value == 234
	assert bin.right is BinaryNode
	right_bin := bin.right as BinaryNode
	assert right_bin.op.symbol == '+'
	assert right_bin.left is IntNode
	assert (right_bin.left as IntNode).value == 56
	assert right_bin.right is IntNode
	assert (right_bin.right as IntNode).value == 78
}

fn test_parse_deep_nested_expr_precise() {
	mut p := new_parser(tokenize_expr('{{((1*24)+(56+78))*5}}')!)
	node := p.parse()!
	assert node is BinaryNode
	root := node as BinaryNode
	assert root.op.symbol == '*'
	assert root.right is IntNode
	assert (root.right as IntNode).value == 5
	assert root.left is BinaryNode
	add1 := root.left as BinaryNode
	assert add1.op.symbol == '+'
	assert add1.left is BinaryNode
	mult := add1.left as BinaryNode
	assert mult.op.symbol == '*'
	assert mult.left is IntNode
	assert (mult.left as IntNode).value == 1
	assert mult.right is IntNode
	assert (mult.right as IntNode).value == 24
	assert add1.right is BinaryNode
	add2 := add1.right as BinaryNode
	assert add2.op.symbol == '+'
	assert add2.left is IntNode
	assert (add2.left as IntNode).value == 56
	assert add2.right is IntNode
	assert (add2.right as IntNode).value == 78
}

fn test_parse_call_simple() {
	mut p := new_parser(tokenize_expr('{{Color "red" "text"}}')!)
	node := p.parse()!
	assert node is CallNode
	call := node as CallNode
	assert call.fn_name == 'Color'
	assert call.args.len == 2
	assert call.args[0] is StringNode
	assert (call.args[0] as StringNode).value == 'red'
	assert call.args[1] is StringNode
	assert (call.args[1] as StringNode).value == 'text'
}

fn test_parse_call_simple_alt_syntax() {
	mut p2 := new_parser(tokenize_expr('{{(Color "red" "text")}}')!)
	node2 := p2.parse()!
	assert node2 is CallNode
	call2 := node2 as CallNode
	assert call2.fn_name == 'Color'
	assert call2.args.len == 2
	assert call2.args[0] is StringNode
	assert (call2.args[0] as StringNode).value == 'red'
	assert call2.args[1] is StringNode
	assert (call2.args[1] as StringNode).value == 'text'
}

fn test_parse_call_nested() {
	mut p := new_parser(tokenize_expr('{{Color "red" (printf "fmt %d" varName)}}')!)
	node := p.parse()!
	assert node is CallNode
	call := node as CallNode
	assert call.fn_name == 'Color'
	assert call.args.len == 2
	assert call.args[0] is StringNode
	assert (call.args[0] as StringNode).value == 'red'
	assert call.args[1] is CallNode
	nested := call.args[1] as CallNode
	assert nested.fn_name == 'printf'
	assert nested.args.len == 2
	assert nested.args[0] is StringNode
	assert (nested.args[0] as StringNode).value == 'fmt %d'
	assert nested.args[1] is IdentNode
	assert (nested.args[1] as IdentNode).name == 'varName'
}

fn test_parse_call_nested_alt_syntax() {
	mut p := new_parser(tokenize_expr('{{(Color "red" (printf "fmt %d" varName))}}')!)
	node := p.parse()!
	assert node is CallNode
	call := node as CallNode
	assert call.fn_name == 'Color'
	assert call.args.len == 2
	assert call.args[0] is StringNode
	assert (call.args[0] as StringNode).value == 'red'
	assert call.args[1] is CallNode
	nested := call.args[1] as CallNode
	assert nested.fn_name == 'printf'
	assert nested.args.len == 2
	assert nested.args[0] is StringNode
	assert (nested.args[0] as StringNode).value == 'fmt %d'
	assert nested.args[1] is IdentNode
	assert (nested.args[1] as IdentNode).name == 'varName'
}
