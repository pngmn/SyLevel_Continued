std = "lua51"
max_line_length = false
exclude_files = {
	"**/libs/**",
	".luacheckrc"
}
ignore = {
	"111",			-- Setting an undefined global variable
	"112",			-- Mutating an undefined global variable
	"113",			-- Accessing an undefined global variable
	"143",			-- Accessing an undefined field of a global variable
	"212/self",		-- Unused argument self
	"212/event",	-- Unused argument event
	"213",			-- Unused loop variable
}