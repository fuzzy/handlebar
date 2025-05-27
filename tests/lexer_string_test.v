module main

import handlebar

fn test_lexer_string_literal() {
	println('Testing lexer for string literal')
	mut l := handlebar.new_lexer('"foo bar baz"')
	tok := l.next_token()
	println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_string
	assert tok.lexeme == 'foo bar baz'
}
