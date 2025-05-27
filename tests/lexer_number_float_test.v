module main

import handlebar

fn test_lexer_number_float() {
	mut l := handlebar.new_lexer('3.14')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '3.14'
}
