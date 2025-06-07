module eval

import token_stream
import parser

interface EvalFunc {}

pub struct EvalMaps {
pub mut:
	ident map[string]parser.AstNode
	func  map[string]fn (args ...parser.AstNode) string
}

pub struct Evaluator {
mut:
	input  string
	output string
	parser parser.Parser
	ast    parser.AstNode
pub mut:
	maps EvalMaps
}

pub fn new_evaluator() Evaluator {
	return Evaluator{
		ast:  parser.IntNode{}
		maps: EvalMaps{
			ident: map[string]parser.AstNode{}
			func:  {
				'add':    add
				'sub':    sub
				'mul':    mul
				'div':    div
				'rem':    rem
				'pow':    pow
				'printf': printf
				'lower':  lower
				'upper':  upper
				'split':  split
			}
		}
	}
}

pub fn (mut ev Evaluator) str() string {
	return ev.output
}

pub fn (mut ev Evaluator) add_ident(k string, v EvalFunc) ! {}

pub fn (mut ev Evaluator) add_func(k string, p fn (args ...parser.AstNode) string) ! {
	ev.maps.func[k] = p
}

fn (mut ev Evaluator) evaluate_call_node(node parser.AstNode) !parser.AstNode {
	match node {
		parser.CallNode {}
		else {
			return error('Unsupported node type: ${node}')
		}
	}
	return error('Unsupported node type: ${node}')
}

pub fn (mut ev Evaluator) evaluate_string(input string) !string {
	ev.input = input
	ev.output = input
	for stream in token_stream.new_token_stream_from_string(input) {
		ev.parser = parser.new_parser(stream)
		ev.ast = ev.parser.parse()!
		match ev.ast {
			parser.CallNode {
				caller := ev.ast as parser.CallNode
				if cb := ev.maps.func[caller.fn_name] {
					return cb(...caller.args)
				}
			}
			else {
				return error('No idea how to deal with this: ${ev.ast}')
			}
		}
	}
	return error('No evaluation happened')
}

fn (mut ev Evaluator) evaluate_callnode(ast parser.AstNode) !string {
	return ''
}

fn (mut ev Evaluator) evaluate_binnode(ast parser.AstNode) !string {
	return ''
}
