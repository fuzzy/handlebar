module handlebar

import strings.textscanner

type Lexer = textscanner.TextScanner

pub fn new_lexer(input string) &Lexer {
	mut l := &Lexer{
		input: input
		ilen:  input.len
		pos:   0
	}
	l.read_char()
	return l
}

fn (mut l Lexer) read_char() rune {
	return rune(l.next())
}

fn (mut l Lexer) get_number() string {
	start := l.pos - 1
	for l.pos < l.input.len && (l.input[l.pos].is_digit() || l.input[l.pos] == `.`) {
		l.read_char()
		l.pos += 1
	}
	return l.input[start..l.pos]
}

fn (mut l Lexer) get_string() string {
	start := l.pos
	for l.pos < l.input.len && l.input[l.pos] != `"` && l.input[l.pos] != 0 {
		l.read_char()
	}
	println('THIS IS A BUG: ${l.input} ${start} ${l.pos} ${l.input[start..l.pos]}')
	if l.pos <= l.input.len && l.input[l.pos] == `"` {
		l.read_char() // skip the closing quote
		value := l.input[start..l.pos]
		return value
	}
	return 'Unterminated string starting at position ${start}'
}

fn (mut l Lexer) get_identifier() string {
	start := l.pos - 1
	l.read_char() // advance past first char
	for l.pos < l.input.len && (l.input[l.pos].is_alnum() || l.input[l.pos] == `_`) {
		l.read_char()
	}
	return l.input[start..l.pos]
}

pub fn (mut l Lexer) next_token() Token {
	mut tok := Token{}

	if l.pos >= l.input.len && l.input.len > 1 {
		println(l)
		return new_token(TokenKind.t_eof, '')
	}

	match rune(l.input[l.pos]) {
		`0`...`9` {
			tok = new_token(TokenKind.t_number, l.get_number())
		}
		`"` {
			tok = new_token(TokenKind.t_string, l.get_string())
		}
		`a`...`z`, `A`...`Z`, `_` {
			tok = new_token(TokenKind.t_ident, l.get_identifier())
		}
		`+`, `-`, `*`, `/`, `%` {
			tok = new_token(TokenKind.t_oper, l.input[l.pos].str())
		}
		`(` {
			tok = new_token(TokenKind.t_lparen, l.input[l.pos - 1].str())
		}
		`)` {
			tok = new_token(TokenKind.t_rparen, l.input[l.pos - 1].str())
		}
		else {
			tok = new_token(TokenKind.t_eof, '')
		}
	}

	l.read_char()
	return tok
}
