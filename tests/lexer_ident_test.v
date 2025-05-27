module main

import handlebar

fn test_lexer_identifiers() {
	println('Testing lexer for identifiers')
	mut l := handlebar.new_lexer('foo')
	tok := l.next_token()
	println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo'
}

fn test_lexer_identifiers_with_numbers() {
	println('Testing lexer for identifiers with numbers')
	mut l := handlebar.new_lexer('foo123')
	tok := l.next_token()
	println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo123'
}

fn test_lexer_identifiers_with_underscore() {
	println('Testing lexer for identifiers with underscore')
	mut l := handlebar.new_lexer('foo_bar')
	tok := l.next_token()
	println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo_bar'
}
