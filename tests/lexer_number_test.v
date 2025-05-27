module main

import handlebar

fn test_lexer_number_literal() {
	mut l := handlebar.new_lexer('42')
	tok := l.next_token()
	assert tok.kind == .t_number
	assert tok.lexeme == '42'
}

// fn test_lexer_number_float() {
// 	mut l := handlebar.new_lexer('3.14')
// 	tok := l.next_token()
// 	assert tok.kind == .t_number
// 	assert tok.lexeme == '3.14'
// }

// fn test_lexer_number_with_leading_zero() {
// 	mut l := handlebar.new_lexer('0123')
// 	tok := l.next_token()
// 	assert tok.kind == .t_number
// 	assert tok.lexeme == '0123'
// }

// fn test_lexer_number_with_trailing_zero() {
// 	mut l := handlebar.new_lexer('1230')
// 	tok := l.next_token()
// 	assert tok.kind == .t_number
// 	assert tok.lexeme == '1230'
// }

// fn test_lexer_number_with_decimal_and_trailing_zero() {
// 	mut l := handlebar.new_lexer('123.0')
// 	tok := l.next_token()
// 	assert tok.kind == .t_number
// 	assert tok.lexeme == '123.0'
// }

// fn test_lexer_number_with_leading_zero_and_decimal() {
// 	mut l := handlebar.new_lexer('0123.456')
// 	tok := l.next_token()
// 	assert tok.kind == .t_number
// 	assert tok.lexeme == '0123.456'
// }

// fn test_lexer_number_decimal_only() {
// 	mut l := handlebar.new_lexer('.456')
// 	tok := l.next_token()
// 	assert tok.kind == .t_number
// 	assert tok.lexeme == '.456'
// }
