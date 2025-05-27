module main

import handlebar

fn test_lexer_identifiers_with_underscore() {
	println('Testing lexer for identifiers with underscore')
	mut l := handlebar.new_lexer('foo_bar')
	tok := l.next_token()
	println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo_bar'
}
