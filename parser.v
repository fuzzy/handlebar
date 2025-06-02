// module parser

// import strconv
// import token
// import token_stream

// // Define AST node types
// interface AstNode {}

// struct IntNode {
// 	value int
// }

// struct FloatNode {
// 	value f64
// }

// struct OperNode {
// 	symbol string
// }

// struct BinaryNode {
// 	left  AstNode
// 	op    OperNode
// 	right AstNode
// }

// struct IdentNode {
// 	name string
// }

// struct AssignNode {
// 	left  IdentNode
// 	right AstNode
// }

// // The parser itself
// pub struct Parser {
// pub mut:
// 	tokens token_stream.TokenStream
// 	maps   struct {
// 		var  map[string]AstNode
// 		func map[string]fn (args []AstNode) AstNode
// 	}
// 	pos    int
// }

// pub fn new_parser(tokens token_stream.TokenStream) Parser {
// 	mut p := Parser{
// 		tokens: tokens
// 		maps:   struct {
// 			var:  map[string]AstNode{}
// 			func: map[string]fn (args []AstNode) AstNode{}
// 		}
// 	}
// 	// println(p)
// 	return p
// }

// fn (mut p Parser) curr() token.Token {
// 	if p.pos < p.tokens.tokens.len {
// 		return p.tokens.tokens[p.pos]
// 	}
// 	return token.Token{
// 		kind:   .t_eof
// 		lexeme: ''
// 	}
// }

// fn (mut p Parser) advance() {
// 	p.pos++
// }

// fn (mut p Parser) peek() token.Token {
// 	return p.tokens.look_ahead()
// }

// pub fn (mut p Parser) parse() !AstNode {
// 	return p.parse_expr()
// }

// fn (mut p Parser) parse_expr() !AstNode {
// 	mut node := p.parse_term()!
// 	for p.curr().kind == .t_oper && (p.curr().lexeme == '+' || p.curr().lexeme == '-') {
// 		op := OperNode{
// 			symbol: p.curr().lexeme
// 		}
// 		p.advance()
// 		right := p.parse_term()!
// 		node = BinaryNode{
// 			left:  node
// 			op:    op
// 			right: right
// 		}
// 	}
// 	return node
// }

// fn (mut p Parser) parse_term() !AstNode {
// 	mut node := p.parse_factor()!
// 	for p.curr().kind == .t_oper && p.curr().lexeme in ['*', '/', '%'] {
// 		op := OperNode{
// 			symbol: p.curr().lexeme
// 		}
// 		p.advance()
// 		right := p.parse_factor()!
// 		node = BinaryNode{
// 			left:  node
// 			op:    op
// 			right: right
// 		}
// 	}
// 	return node
// }

// fn (mut p Parser) parse_factor() !AstNode {
// 	tok := p.curr()
// 	if tok.lexeme.len == 0 {
// 		return error('unexpected end of input')
// 	}

// 	if tok.kind == .t_lparen {
// 		p.advance()
// 		val := p.parse_expr()!
// 		if p.curr().kind != .t_rparen {
// 			return error('expected ")", got "${p.curr().lexeme}"')
// 		}
// 		p.advance()
// 		return val
// 	}

// 	p.advance()
// 	if val := strconv.atoi(tok.lexeme) {
// 		return IntNode{
// 			value: val
// 		}
// 	} else if val := strconv.atof64(tok.lexeme) {
// 		return FloatNode{
// 			value: val
// 		}
// 	}
// 	return error('invalid number literal: ${tok.lexeme}')
// }
module parser

import strconv
import token
import token_stream

// Define AST node types
interface AstNode {}

struct IntNode {
	value int
}

struct FloatNode {
	value f64
}

struct OperNode {
	symbol string
}

struct BinaryNode {
	left  AstNode
	op    OperNode
	right AstNode
}

struct IdentNode {
	name string
}

struct AssignNode {
	left  IdentNode
	right AstNode
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

// Top‐level parse: check for assignment or fallback to expression
pub fn (mut p Parser) parse() !AstNode {
	// If current token is IDENT and next is t_assign, do assignment
	if p.curr().kind == .t_ident && p.peek().kind == .t_assign {
		return p.parse_assign()
	}
	return p.parse_expr()
}

fn (mut p Parser) parse_assign() !AstNode {
	// Left side must be IDENT
	ident_tok := p.curr()
	p.advance() // consume identifier

	// Now current should be t_assign
	if p.curr().kind != .t_assign {
		return error('expected "=", got "${p.curr().lexeme}"')
	}
	p.advance() // consume "="

	// Parse RHS expression
	right_node := p.parse_expr()!
	return AssignNode{
		left:  IdentNode{
			name: ident_tok.lexeme
		}
		right: right_node
	}
}

fn (mut p Parser) parse_expr() !AstNode {
	mut node := p.parse_term()!
	for p.curr().kind == .t_oper && (p.curr().lexeme == '+' || p.curr().lexeme == '-') {
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

	// Parenthesized sub‐expression
	if tok.kind == .t_lparen {
		p.advance()
		val := p.parse_expr()!
		if p.curr().kind != .t_rparen {
			return error('expected ")", got "${p.curr().lexeme}"')
		}
		p.advance()
		return val
	}

	// If it's an identifier, return IdentNode
	if tok.kind == .t_ident {
		p.advance()
		return IdentNode{
			name: tok.lexeme
		}
	}

	// Otherwise it must be a number literal
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
	return error('invalid number literal: ${tok.lexeme}')
}
