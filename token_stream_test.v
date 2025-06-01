module token_stream

import token

fn test_tokenstream_current_and_next() {
	toks := [
		token.new_token(.t_ident, 'foo'),
		token.new_token(.t_number, '42'),
	]
	mut s := TokenStream{
		tokens: toks
		pos:    0
	}
	assert s.current().lexeme == 'foo'
	s.next()
	assert s.current().lexeme == '42'
	s.next()
	assert s.current().kind == .t_eof
}

fn test_tokenstream_peek_lookahead_lookback() {
	toks := [
		token.new_token(.t_ident, 'x'),
		token.new_token(.t_oper, '+'),
		token.new_token(.t_ident, 'y'),
	]
	mut s := TokenStream{
		tokens: toks
		pos:    0
	}
	s.next() // Move to the next token
	assert s.look_back().lexeme == 'x'
	assert s.look_ahead().lexeme == 'y'
}

fn test_new_token_stream_from_string() {
	stream := new_token_stream_from_string('{{foo + 1}}')

	// First stream: "foo + 1"
	assert stream[0].tokens.len >= 3
	assert stream[0].tokens[0].kind == .t_ident
	assert stream[0].tokens[0].lexeme == 'foo'
	assert stream[0].tokens[1].kind == .t_oper
	assert stream[0].tokens[1].lexeme == '+'
	assert stream[0].tokens[2].kind == .t_number
	assert stream[0].tokens[2].lexeme == '1'
}
