module main

import handlebar

fn test_lexer_number_with_trailing_zero() {
	mut l := handlebar.new_lexer('1230')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '1230'
}
