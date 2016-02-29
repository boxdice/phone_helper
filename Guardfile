guard :minitest, all_on_start: false do
  watch(%r{^lib/(.*)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
end

guard :rubocop, all_on_start: false, keep_failed: false do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
