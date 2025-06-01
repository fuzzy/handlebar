module blob

fn test_blob_extraction() {
	raw := 'text {{hello}} more {{world}}'
	blobs := get_blobs(raw)
	assert blobs.len == 2
	assert blobs[0].str() == 'hello'
	assert blobs[1].str() == 'world'
}
