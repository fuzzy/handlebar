module main

import handlebar

fn test_lexer_parentheses() {
	println('Testing lexer for parentheses')
	mut l := handlebar.new_lexer('()')
	tok_a := l.next_token()
	tok_b := l.next_token()
	println('Lexer output: ${tok_a.lexeme}, ${tok_b.lexeme}\n')
	assert tok_a.kind == .t_lparen
	assert tok_b.kind == .t_rparen
}
