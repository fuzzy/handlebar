module eval

fn test_add_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{add 23 2.71}}')! == '25.71'
}

fn test_sub_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{sub 23 3}}')! == '20'
}

fn test_mul_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{mul 2 7}}')! == '14'
}

fn test_div_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{div 25 2}}')! == '12'
}

fn test_rem_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{rem 25 2}}')! == '1'
}

fn test_pow_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{pow 1024 2}}')! == '1048576'
}

fn test_printf_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{printf "%.02f" 1.1}}')! == '1.10'
	assert ev.evaluate_string('{{printf "%02d" 1}}')! == '01'
}

fn test_lower_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{lower "TEST"}}')! == 'test'
}

fn test_upper_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{upper "test"}}')! == 'TEST'
}

fn test_split_func() {
	mut ev := new_evaluator()
	assert ev.evaluate_string('{{split "123,test,foo" "," 1}}')! == 'test'
}
