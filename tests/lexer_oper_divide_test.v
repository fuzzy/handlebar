module main

import handlebar

fn test_lexer_operator_divide() {
	mut l := handlebar.new_lexer('/')
	tok := l.next_token()
	assert tok.kind == .t_oper
	assert tok.lexeme.len == 1
	assert tok.lexeme == `/`.str()
}
