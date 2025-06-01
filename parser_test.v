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
	// println('## DEBUG: ${p}')
	node := p.parse()!
	// println('#### DEBUG: ${node}')
	assert node is BinaryNode
	bin := node as BinaryNode
	// println('###### DEBUG: ${bin}')
	assert bin.left is IntNode
	assert (bin.left as IntNode).value == 7
	assert bin.op.symbol == '%'
	assert bin.right is FloatNode
	assert (bin.right as FloatNode).value == 2.23
}

// fn test_parse_func_call() {
// 	mut p := new_parser(tokenize_expr('{{(printf "format" ident)}}')!)
// 	// println('## DEBUG: ${p}')
// 	node := p.parse()!
// 	// println('#### DEBUG: ${node}')
// 	assert node is BinaryNode
// 	bin := node as BinaryNode
// 	// println('###### DEBUG: ${bin}')
// 	assert bin.left is IntNode
// 	assert (bin.left as IntNode).value == 7
// 	assert bin.op.symbol == '%'
// 	assert bin.right is FloatNode
// 	assert (bin.right as FloatNode).value == 2.23
// }

fn test_parse_nested_expr() {
	mut p := new_parser(tokenize_expr('{{(1 * 234) + (56 + 78)}}')!)
	node := p.parse()!
	assert node is BinaryNode

	// Top-level BinaryNode: (1 * 234) + (56 + 78)
	bin := node as BinaryNode
	assert bin.op.symbol == '+'

	// Left side: (1 * 234)
	assert bin.left is BinaryNode
	left_bin := bin.left as BinaryNode
	assert left_bin.op.symbol == '*'
	assert left_bin.left is IntNode
	assert (left_bin.left as IntNode).value == 1
	assert left_bin.right is IntNode
	assert (left_bin.right as IntNode).value == 234

	// Right side: (56 + 78)
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

	// Top-level BinaryNode: (((1 * 24) + (56 + 78)) * 5)
	root := node as BinaryNode
	assert root.op.symbol == '*'

	// Right side: 5
	assert root.right is IntNode
	assert (root.right as IntNode).value == 5

	// Left side: (1 * 24) + (56 + 78)
	assert root.left is BinaryNode
	add1 := root.left as BinaryNode
	assert add1.op.symbol == '+'

	// Left of +: (1 * 24)
	assert add1.left is BinaryNode
	mult := add1.left as BinaryNode
	assert mult.op.symbol == '*'
	assert mult.left is IntNode
	assert (mult.left as IntNode).value == 1
	assert mult.right is IntNode
	assert (mult.right as IntNode).value == 24

	// Right of +: (56 + 78)
	assert add1.right is BinaryNode
	add2 := add1.right as BinaryNode
	assert add2.op.symbol == '+'
	assert add2.left is IntNode
	assert (add2.left as IntNode).value == 56
	assert add2.right is IntNode
	assert (add2.right as IntNode).value == 78
}
