module main

import handlebar

fn test_lexer_identifiers_with_numbers() {
	println('Testing lexer for identifiers with numbers')
	mut l := handlebar.new_lexer('foo123')
	tok := l.next_token()
	println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo123'
}
