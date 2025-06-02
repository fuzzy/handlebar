module lexer

import strings.textscanner
import token

type Lexer = textscanner.TextScanner

pub fn new_lexer(input string) &Lexer {
	mut l := &Lexer{
		input: input
		ilen:  input.len
		pos:   0
	}
	// if l.input.len > 1 {
	// 	l.read_char()
	// }
	return l
}

fn (mut l Lexer) read_char() rune {
	return rune(l.next())
}

fn (mut l Lexer) get_number() string {
	start := l.pos
	for l.pos < l.input.len && (l.input[l.pos].is_digit() || l.input[l.pos] == `.`) {
		l.read_char()
	}
	return l.input[start..l.pos]
}

fn (mut l Lexer) get_string() string {
	l.read_char() // Skip the opening quote
	start := l.pos
	for l.pos < l.input.len && l.input[l.pos] != `"` {
		l.read_char()
	}
	value := l.input[start..l.pos]
	return value
}

fn (mut l Lexer) get_identifier() string {
	start := l.pos
	for l.pos < l.input.len && (l.input[l.pos].is_alnum() || l.input[l.pos] == `_`) {
		l.read_char()
	}
	return l.input[start..l.pos]
}

pub fn (mut l Lexer) next_token() token.Token {
	// Skip whitespace BEFORE match
	for l.pos < l.input.len && l.input[l.pos].is_space() {
		l.read_char()
	}

	if l.pos >= l.input.len {
		return token.new_token(token.TokenKind.t_eof, '')
	}

	mut tok := token.Token{}

	match rune(l.input[l.pos]) {
		`0`...`9`, `.` {
			tok = token.new_token(token.TokenKind.t_number, l.get_number())
		}
		`"` {
			tok = token.new_token(token.TokenKind.t_string, l.get_string())
		}
		`a`...`z`, `A`...`Z`, `_` {
			tok = token.new_token(token.TokenKind.t_ident, l.get_identifier())
		}
		`+`, `-`, `*`, `/`, `%` {
			if l.pos + 1 > l.input.len {
				tok = token.new_token(token.TokenKind.t_eof, '')
			} else {
				tok = token.new_token(token.TokenKind.t_oper, l.input[l.pos..l.pos + 1])
			}
			l.next()
		}
		`=` {
			tok = token.new_token(token.TokenKind.t_assign, rune(l.input[l.pos]).str())
			l.next()
		}
		`)` {
			tok = token.new_token(token.TokenKind.t_rparen, rune(l.input[l.pos]).str())
			l.next()
		}
		`(` {
			tok = token.new_token(token.TokenKind.t_lparen, rune(l.input[l.pos]).str())
			l.next()
		}
		else {
			tok = token.new_token(token.TokenKind.t_eof, '')
			l.next()
		}
	}

	return tok
}
