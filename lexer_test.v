module lexer

fn test_lexer_identifiers() {
	// println('Testing lexer for identifiers')
	mut l := new_lexer('foo')
	tok := l.next_token()
	// println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo'
}

fn test_lexer_identifiers_with_numbers() {
	// println('Testing lexer for identifiers with numbers')
	mut l := new_lexer('foo123')
	tok := l.next_token()
	// println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo123'
}

fn test_lexer_identifiers_with_underscore() {
	// println('Testing lexer for identifiers with underscore')
	mut l := new_lexer('foo_bar')
	tok := l.next_token()
	// println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_ident
	assert tok.lexeme == 'foo_bar'
}

fn test_lexer_number_literal() {
	mut l := new_lexer('42')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '42'
}

fn test_lexer_number_float() {
	mut l := new_lexer('3.14')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '3.14'
}

fn test_lexer_number_with_leading_zero() {
	mut l := new_lexer('0123')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '0123'
}

fn test_lexer_number_with_trailing_zero() {
	mut l := new_lexer('1230')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '1230'
}

fn test_lexer_number_with_decimal_and_trailing_zero() {
	mut l := new_lexer('123.0')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '123.0'
}

fn test_lexer_number_with_leading_zero_and_decimal() {
	mut l := new_lexer('0123.456')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '0123.456'
}

fn test_lexer_number_decimal_only() {
	mut l := new_lexer('.456')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '.456'
}

fn test_lexer_operator_plus() {
	mut l := new_lexer('+')
	tok := l.next_token()
	assert tok.kind == .t_oper
	assert tok.lexeme.len == 1
	assert tok.lexeme == `+`.str()
}

fn test_lexer_operator_minus() {
	mut l := new_lexer('-')
	tok := l.next_token()
	assert tok.kind == .t_oper
	assert tok.lexeme.len == 1
	assert tok.lexeme == `-`.str()
}

fn test_lexer_operator_multiply() {
	mut l := new_lexer('*')
	tok := l.next_token()
	assert tok.kind == .t_oper
	assert tok.lexeme.len == 1
	assert tok.lexeme == `*`.str()
}

fn test_lexer_operator_divide() {
	mut l := new_lexer('/')
	tok := l.next_token()
	assert tok.kind == .t_oper
	assert tok.lexeme.len == 1
	assert tok.lexeme == `/`.str()
}

fn test_lexer_operator_remainder() {
	mut l := new_lexer('%')
	tok := l.next_token()
	assert tok.kind == .t_oper
	assert tok.lexeme.len == 1
	assert tok.lexeme == `%`.str()
}

fn test_lexer_parentheses() {
	// println('Testing lexer for parentheses')
	mut l := new_lexer('()')
	tok_a := l.next_token()
	tok_b := l.next_token()
	// println('Lexer output: ${tok_a.lexeme}, ${tok_b.lexeme}\n')
	assert tok_a.kind == .t_lparen
	assert tok_b.kind == .t_rparen
}

fn test_lexer_string_literal() {
	// println('Testing lexer for string literal')
	mut l := new_lexer('"foo bar baz"')
	tok := l.next_token()
	// println('Lexer output: ${tok.lexeme}\n')
	assert tok.kind == .t_string
	assert tok.lexeme == 'foo bar baz'
}
