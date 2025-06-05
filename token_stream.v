module token_stream

import blob
import token
import lexer

pub struct TokenStream {
pub mut:
	tokens []token.Token
	pos    int
}

pub fn (mut s TokenStream) str() string {
	mut retv := ''
	for tok in s.tokens {
		if retv.len > 0 {
			retv += ' '
		}
		retv += tok.lexeme
	}
	return retv
}

pub fn (mut s TokenStream) current() token.Token {
	return if s.pos < s.tokens.len {
		s.tokens[s.pos]
	} else {
		token.Token{
			kind:   .t_eof
			lexeme: ''
		}
	}
}

pub fn new_token_stream(tokens []token.Token) TokenStream {
	return TokenStream{
		tokens: tokens
		pos:    0
	}
}

pub fn new_token_stream_from_string(input string) []TokenStream {
	mut streams := []TokenStream{}
	for b in blob.get_blobs(input) {
		mut lex := lexer.new_lexer(b.str())
		mut toks := []token.Token{}
		for {
			tok := lex.next_token()
			toks << tok
			if tok.kind == .t_eof {
				break
			}
		}
		streams << new_token_stream(toks)
	}
	return streams
}

pub fn (mut s TokenStream) next() token.Token {
	s.pos++
	if s.pos < s.tokens.len {
		return s.tokens[s.pos]
	}
	s.pos++
	return token.Token{
		kind:   .t_eof
		lexeme: ''
	}
}

fn (s TokenStream) peek(n int) token.Token {
	idx := s.pos + n
	if idx >= 0 && idx < s.tokens.len {
		return s.tokens[idx]
	}
	return token.Token{
		kind:   .t_eof
		lexeme: ''
	}
}

pub fn (mut s TokenStream) look_ahead() token.Token {
	return s.peek(1)
}

pub fn (mut s TokenStream) look_back() token.Token {
	return s.peek(-1)
}

pub fn (mut s TokenStream) expect(kind token.TokenKind) token.Token {
	tok := s.current()
	if tok.kind != kind {
		panic('expected ${kind}, got ${tok.kind}')
	}
	s.next()
	return tok
}
