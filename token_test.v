module token

fn test_token_creation() {
	kinds := [
		TokenKind.t_ident,
		TokenKind.t_string,
		TokenKind.t_number,
		TokenKind.t_bool,
		TokenKind.t_compr,
		TokenKind.t_oper,
		TokenKind.t_keyword,
		TokenKind.t_func,
		TokenKind.t_land,
		TokenKind.t_lor,
		TokenKind.t_lparen,
		TokenKind.t_rparen,
		TokenKind.t_eof,
		TokenKind.t_error,
	]
	for kind in kinds {
		tok := new_token(kind, 'test')
		assert tok.kind == kind
		assert tok.lexeme == 'test'
	}
}
