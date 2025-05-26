module handlebar

enum TokenKind as u8 {
	t_ident   // Alphanumeric or _ (e.g. Foo123)
	t_string  // "literal string"
	t_number  // all treated as f65
	t_bool    // true, false
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
}

pub struct Token {
	kind   TokenKind
	lexeme string
}

pub fn new_token(kind TokenKind, lexeme string) Token {
	return Token{
		kind:   kind
		lexeme: lexeme
	}
}
