module main

import handlebar

fn test_lexer_number_with_decimal_and_trailing_zero() {
	mut l := handlebar.new_lexer('123.0')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '123.0'
}
