module blob

import regex

struct Blob {
pub mut:
	val string
}

fn (b &Blob) trim() string {
	return b.val[2..(b.val.len - 2)]
}

pub fn (b &Blob) str() string {
	return b.trim()
}

pub fn get_blobs(input string) []&Blob {
	mut retv := []&Blob{}
	mut re := regex.regex_opt(r'(\{\{.*\}\})') or { panic('Failed to compile regex: ${err}') }
	for elem in re.find_all_str(input) {
		mut b := &Blob{}
		b.val = elem
		retv << b
	}
	return retv
}
