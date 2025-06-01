module token

pub enum TokenKind as u8 {
	t_ident   // Alphanumeric or _ (e.g. Foo123)
	t_string  // "literal string"
	t_number  // all treated as f65
	t_bool    // true, false
	t_assign  // =, +=, -=, *=, /=
	t_compr   // ==, !=, <, >, <=, >=
	t_oper    // +, -, *, /, etc.
	t_keyword // if, else, for, etc.
	t_func    // function name
	t_land    // &&
	t_lor     // ||
	t_lparen  // (
	t_rparen  // )
	t_eof     // End of file
	t_error   // Error token
	t_comma   // ,
}

pub struct Token {
pub:
	kind   TokenKind
	lexeme string
}

pub fn (t Token) is_operator() bool {
	return t.kind == .t_oper && t.lexeme in ['+', '-', '*', '/', '%']
}

pub fn (t Token) is_comparator() bool {
	return t.kind == .t_compr && t.lexeme in ['==', '!=', '<', '<=', '>', '>=']
}

pub fn (t Token) is_assignor() bool {
	return t.kind == .t_assign && t.lexeme in ['=', '+=', '-=', '*=', '/=']
}

pub fn new_token(kind TokenKind, lexeme string) Token {
	return Token{
		kind:   kind
		lexeme: lexeme
	}
}
