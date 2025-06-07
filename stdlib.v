module eval

import math
import strconv
import parser

// math bits

fn math_helper(args ...parser.AstNode) (f64, f64, bool) {
	assert args.len == 2

	mut a := f64(0)
	mut b := f64(0)

	if args[0] is parser.IntNode {
		a = (args[0] as parser.IntNode).val()
	} else if args[0] is parser.FloatNode {
		a = (args[0] as parser.FloatNode).val()
	}

	if args[1] is parser.IntNode {
		b = (args[1] as parser.IntNode).val()
	} else if args[1] is parser.FloatNode {
		b = (args[1] as parser.FloatNode).val()
	}

	if args[0] is parser.FloatNode || args[1] is parser.FloatNode {
		return a, b, true
	}
	return a, b, false
}

fn add(args ...parser.AstNode) string {
	a, b, f := math_helper(...args)

	if f {
		return '${a + b}'
	}
	return '${int(a) + int(b)}'
}

fn sub(args ...parser.AstNode) string {
	a, b, f := math_helper(...args)
	if f {
		return '${a - b}'
	}
	return '${int(a) - int(b)}'
}

fn mul(args ...parser.AstNode) string {
	a, b, f := math_helper(...args)
	if f {
		return '${a * b}'
	}
	return '${int(a) * int(b)}'
}

fn div(args ...parser.AstNode) string {
	a, b, f := math_helper(...args)
	if f {
		return '${a / b}'
	}
	return '${int(a) / int(b)}'
}

fn rem(args ...parser.AstNode) string {
	a, b, f := math_helper(...args)
	if f {
		retv := math.fmod(a, b)
		return '${retv}'
	}
	return '${int(a) % int(b)}'
}

fn pow(args ...parser.AstNode) string {
	a, b, _ := math_helper(...args)
	res := math.pow(a, b)
	mut param := strconv.BF_param{}
	param.len1 = 0
	param.rm_tail_zero = true
	return strconv.format_fl(res, param)
}

// string bits

fn printf(args ...parser.AstNode) string {
	println('####### DEBUG: ${args}')
	unsafe {
		assert args.len >= 1
		mut fmt_node := (args[0] as parser.StringNode).str()
		mut v_args := []voidptr{}
		mut int_vals := []int{}
		mut float_vals := []f64{}
		mut str_vals := []string{}

		for i in 1 .. args.len {
			node := args[i]
			println('INTERNAL DEBUG: ${node}')
			match node {
				parser.IntNode {
					iv := (args[i] as parser.IntNode).val()
					int_vals << iv
					v_args << voidptr(&int_vals[int_vals.len - 1])
				}
				parser.FloatNode {
					fv := (args[i] as parser.FloatNode).val()
					float_vals << fv
					v_args << voidptr(&float_vals[float_vals.len - 1])
				}
				parser.StringNode {
					sv := (args[i] as parser.StringNode).str()
					str_vals << sv
					v_args << voidptr(&str_vals[str_vals.len - 1])
				}
				else {
					panic('printf: unsupported node type ${node}')
				}
			}
		}

		return strconv.v_sprintf(fmt_node, ...v_args)
	}
}

fn upper(args ...parser.AstNode) string {
	assert args.len == 1
	node := args[0]
	match node {
		parser.StringNode {
			return (args[0] as parser.StringNode).str().to_upper()
		}
		else {
			panic('upper: expected a StringNode, got: ${args}[0]')
		}
	}
}

fn lower(args ...parser.AstNode) string {
	assert args.len == 1
	node := args[0]
	match node {
		parser.StringNode {
			return (args[0] as parser.StringNode).str().to_lower()
		}
		else {
			panic('lower: expected a StringNode, got: ${args}[0]')
		}
	}
}

fn split(args ...parser.AstNode) string {
	// args[0]: original string
	// args[1]: delimiter (substring)
	// args[2]: index (IntNode)
	assert args.len == 3
	mut s := ''
	node_a := args[0]
	match node_a {
		parser.StringNode {
			s = (args[0] as parser.StringNode).str()
		}
		else {
			panic('split: first argument must be a StringNode, got: ${args}[0]')
		}
	}

	mut delim := ''
	node_b := args[1]
	match node_b {
		parser.StringNode {
			delim = (args[1] as parser.StringNode).str()
		}
		else {
			panic('split: second argument must be a StringNode (delimiter), got: ${args}[1]')
		}
	}

	mut idx := 0
	node_c := args[2]
	match node_c {
		parser.IntNode {
			idx = (args[2] as parser.IntNode).val()
		}
		else {
			panic('split: third argument must be an IntNode (index), got: ${args}[2]')
		}
	}

	parts := s.split(delim)
	if idx < 0 || idx >= parts.len {
		panic('split: index ${idx} out of range (0..${parts.len - 1})')
	}

	return parts[idx]
}
