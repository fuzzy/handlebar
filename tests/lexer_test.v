module main

import handlebar

fn test_lexer_identifiers() {
	mut l := handlebar.new_lexer('foo')
	tok := l.next_token()
	println('identifier: ${tok.lexeme}')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo'
}

fn test_lexer_number_literal() {
	mut l := handlebar.new_lexer('42')
	tok := l.next_token()
	println('number: ${tok.lexeme}')
	assert tok.kind == .t_number
	assert tok.lexeme == '42'
}

fn test_lexer_operator() {
	mut l := handlebar.new_lexer('+')
	tok := l.next_token()
	println('Operator token: ${tok.lexeme}')
	assert tok.kind == .t_oper
	assert tok.lexeme == '+'
}

fn test_lexer_parentheses() {
	mut l := handlebar.new_lexer('()')
	assert l.next_token().kind == .t_lparen
	assert l.next_token().kind == .t_rparen
}

fn test_lexer_string_literal() {
	mut l := handlebar.new_lexer('"bar"')
	tok := l.next_token()
	println('STUPID FUCKING DEBUG LINE: ${tok.lexeme}')
	assert tok.kind == .t_string
	assert tok.lexeme == '"bar"'
}
