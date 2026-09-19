local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local snips = require("go.snips")
local in_fn = {
	show_condition = snips.in_function,
	condition = snips.in_function,
}

-- Go
ls.add_snippets("go", {
	ls.s(
		{ trig = "ife", name = "If error, choose me!", dscr = "If error, return wrapped with dynamic node" },
		fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
			ls.i(1, "err"),
			ls.d(2, snips.make_return_nodes, { 1 }, { user_args = { { "a1", "a2" } } }),
			ls.i(0),
		}),
		in_fn
	),
})
