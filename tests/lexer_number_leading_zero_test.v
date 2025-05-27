module main

import handlebar

fn test_lexer_number_with_leading_zero() {
	mut l := handlebar.new_lexer('0123')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '0123'
}
