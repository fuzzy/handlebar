module parser

import strconv
import token
import token_stream

// Define AST node types
pub interface AstNode {}

pub struct IntNode {
	value int
}

pub fn (i IntNode) val() int {
	return i.value
}

pub fn (i IntNode) str() string {
	return '${i.value}'
}

pub struct FloatNode {
	value f64
}

pub fn (i FloatNode) val() f64 {
	return i.value
}

pub fn (i FloatNode) str() string {
	return '${i.value}'
}

pub struct StringNode {
	value string
}

pub fn (i StringNode) str() string {
	return '${i.value}'
}

pub struct OperNode {
	symbol string
}

pub fn (i OperNode) str() string {
	return '${i.symbol}'
}

pub struct BinaryNode {
	left  AstNode
	op    OperNode
	right AstNode
}

pub struct IdentNode {
	name string
}

pub fn (i IdentNode) str() string {
	return '${i.name}'
}

pub struct AssignNode {
	left  IdentNode
	right AstNode
}

pub struct CallNode {
pub:
	fn_name string
	args    []AstNode
}

// The parser itself
pub struct Parser {
pub mut:
	tokens token_stream.TokenStream
	maps   struct {
		var  map[string]AstNode
		func map[string]fn (args []AstNode) AstNode
	}
	pos    int
}

pub fn new_parser(tokens token_stream.TokenStream) Parser {
	mut p := Parser{
		tokens: tokens
		maps:   struct {
			var:  map[string]AstNode{}
			func: map[string]fn (args []AstNode) AstNode{}
		}
	}
	return p
}

fn (mut p Parser) curr() token.Token {
	if p.pos < p.tokens.tokens.len {
		return p.tokens.tokens[p.pos]
	}
	return token.Token{
		kind:   .t_eof
		lexeme: ''
	}
}

fn (mut p Parser) advance() {
	p.pos++
}

fn (mut p Parser) peek() token.Token {
	return p.tokens.look_ahead()
}

// Top-level parse: check for assignment or fallback to expression
pub fn (mut p Parser) parse() !AstNode {
	if p.curr().kind == .t_ident && p.peek().kind == .t_assign {
		return p.parse_assign()
	}
	return p.parse_expr()
}

fn (mut p Parser) parse_assign() !AstNode {
	ident_tok := p.curr()
	p.advance() // consume identifier

	if p.curr().kind != .t_assign {
		return error('expected "=", got "${p.curr().lexeme}"')
	}
	p.advance() // consume "="

	right_node := p.parse_expr()!
	return AssignNode{
		left:  IdentNode{
			name: ident_tok.lexeme
		}
		right: right_node
	}
}

// Parse expressions, including pipe operator '|' with lowest precedence
fn (mut p Parser) parse_expr() !AstNode {
	mut node := p.parse_term()!
	for p.curr().kind == .t_oper
		&& (p.curr().lexeme == '+' || p.curr().lexeme == '-' || p.curr().lexeme == '|') {
		op := OperNode{
			symbol: p.curr().lexeme
		}
		p.advance()
		right := p.parse_term()!
		node = BinaryNode{
			left:  node
			op:    op
			right: right
		}
	}
	return node
}

// parse_term handles * / % with higher precedence than + - |
fn (mut p Parser) parse_term() !AstNode {
	mut node := p.parse_factor()!
	for p.curr().kind == .t_oper && p.curr().lexeme in ['*', '/', '%'] {
		op := OperNode{
			symbol: p.curr().lexeme
		}
		p.advance()
		right := p.parse_factor()!
		node = BinaryNode{
			left:  node
			op:    op
			right: right
		}
	}
	return node
}

fn (mut p Parser) parse_factor() !AstNode {
	tok := p.curr()
	if tok.lexeme.len == 0 {
		return error('unexpected end of input')
	}

	if tok.kind == .t_lparen {
		p.advance()
		if p.curr().kind == .t_ident {
			fn_name := p.curr().lexeme
			p.advance()

			mut args := []AstNode{}
			for p.curr().kind != .t_rparen && p.curr().kind != .t_eof {
				arg := p.parse_expr()!
				args << arg
			}
			if p.curr().kind != .t_rparen {
				return error('expected ")", got "${p.curr().lexeme}"')
			}
			p.advance() // consume ')'
			return CallNode{
				fn_name: fn_name
				args:    args
			}
		}

		val := p.parse_expr()!
		if p.curr().kind != .t_rparen {
			return error('expected ")", got "${p.curr().lexeme}"')
		}
		p.advance()
		return val
	}

	if tok.kind == .t_string {
		p.advance()
		return StringNode{
			value: tok.lexeme
		}
	}

	if tok.kind == .t_number {
		p.advance()
		if val := strconv.atoi(tok.lexeme) {
			return IntNode{
				value: val
			}
		} else if val := strconv.atof64(tok.lexeme) {
			return FloatNode{
				value: val
			}
		}
		return error('invalid number: ${tok.lexeme}')
	}

	if tok.kind == .t_ident {
		fn_name := tok.lexeme
		p.advance()
		next := p.curr()
		if next.kind == .t_string || next.kind == .t_number || next.kind == .t_ident
			|| next.kind == .t_lparen {
			mut args := []AstNode{}
			for {
				t := p.curr()
				if t.kind == .t_eof || t.kind == .t_rparen || t.kind == .t_oper {
					break
				}
				arg := p.parse_factor()!
				args << arg
			}
			return CallNode{
				fn_name: fn_name
				args:    args
			}
		}

		return IdentNode{
			name: fn_name
		}
	}

	return error('invalid token in parse_factor(): ${tok.lexeme}')
}
