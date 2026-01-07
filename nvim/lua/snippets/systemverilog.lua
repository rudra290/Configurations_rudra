local ls = require("luasnip")
local s  = ls.snippet
local i  = ls.insert_node
local d  = ls.dynamic_node
local c  = ls.choice_node
local t  = ls.text_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------

local function fname()
    local n = vim.fn.expand("%:t:r")
    return (n ~= "" and n) or "name"
end

local function detect(patterns, default)
    for _, p in ipairs(patterns) do
        if vim.fn.search("\\<" .. p .. "\\>", "nw") ~= 0 then
            return p
        end
    end
    return default
end

local function clk() return detect({ "clk", "i_clk", "clock" }, "clk") end
local function rst() return detect({ "rst_n", "reset_n", "rst", "reset" }, "rst_n") end

---------------------------------------------------------------------
-- SNIPPETS
---------------------------------------------------------------------

ls.add_snippets("systemverilog", {

---------------------------------------------------------------------
-- 🔥 MODULE (filename aware, autoinst ready)
---------------------------------------------------------------------
s("mod",
fmt([[
module {} #(
    parameter int DATA_WIDTH = {}
) (
    input  logic {},
    input  logic {},
    {}
);

    {}

endmodule
]],
{
    i(1, fname()),
    i(2, "32"),
    i(3, clk()),
    i(4, rst()),
    i(5, "// ports"),
    i(6, "// logic"),
})),

---------------------------------------------------------------------
-- ⚙️ PACKAGE (filename aware)
---------------------------------------------------------------------
s("pkg",
fmt([[
package {}_pkg;

    parameter int DATA_WIDTH = {};

endpackage : {}_pkg
]],
{
    i(1, fname()),
    i(2, "32"),
    i(3, fname()),
})),

---------------------------------------------------------------------
-- 🧠 PARAMETERIZED INTERFACE
---------------------------------------------------------------------
s("ifc",
fmt([[
interface {}_if #(
    parameter int DATA_WIDTH = {}
) (input logic {});

    logic [{}:0] data;
    logic        valid;
    logic        ready;

    modport master (output data, valid, input ready);
    modport slave  (input  data, valid, output ready);

endinterface : {}_if
]],
{
    i(1, fname()),
    i(2, "32"),
    i(3, clk()),
    i(4, "DATA_WIDTH-1"),
    i(5, fname()),
})),

---------------------------------------------------------------------
-- 🧩 ALWAYS_FF (async / sync reset)
---------------------------------------------------------------------
s("aff",
fmt([[
always_ff @(posedge {}{}) begin
    if ({}) begin
        {}
    end else begin
        {}
    end
end
]],
{
    i(1, clk()),
    c(2, { t(" or negedge " .. rst()), t("") }),
    c(3, { t("!" .. rst()), t(rst()) }),
    i(4, "// reset"),
    i(5, "// logic"),
})),

---------------------------------------------------------------------
-- 🧠 FSM (auto width)
---------------------------------------------------------------------
s("fsm",
fmt([[
localparam int NUM_STATES = {};

typedef enum logic [$clog2(NUM_STATES)-1:0] {{
    {}
}} state_t;

state_t state, next_state;

always_ff @(posedge {} or negedge {}) begin
    if (!{}) state <= {};
    else     state <= next_state;
end

always_comb begin
    next_state = state;
    case (state)
        {}
        default: next_state = {};
    endcase
end
]],
{
    i(1, "4"),
    i(2, "IDLE"),
    i(3, clk()),
    i(4, rst()),
    i(5, rst()),
    i(6, "IDLE"),
    i(7, "// states"),
    i(8, "IDLE"),
})),

---------------------------------------------------------------------
-- 🧩 CDC (2-FF synchronizer)
---------------------------------------------------------------------
s("cdc",
fmt([[
logic sync_ff1, sync_ff2;

always_ff @(posedge {} or negedge {}) begin
    if (!{}) begin
        sync_ff1 <= 1'b0;
        sync_ff2 <= 1'b0;
    end else begin
        sync_ff1 <= {};
        sync_ff2 <= sync_ff1;
    end
end
]],
{
    i(1, clk()),
    i(2, rst()),
    i(3, rst()),
    i(4, "async_sig"),
})),

---------------------------------------------------------------------
-- 🧠 PARAMETER PROPAGATION
---------------------------------------------------------------------
s("paraminst",
fmt([[
{} #(
    .DATA_WIDTH ({}),
    .ADDR_WIDTH ({})
) u_{} (
    /*AUTOINST*/
);
]],
{
    i(1, "child_module"),
    i(2, "DATA_WIDTH"),
    i(3, "ADDR_WIDTH"),
    i(4, "child"),
})),

---------------------------------------------------------------------
-- 🔗 AUTOINST FRIENDLY INSTANCE
---------------------------------------------------------------------
s("inst",
fmt([[
{} u_{} (
    /*AUTOINST*/
);
]],
{
    i(1, "module_name"),
    i(2, "inst"),
})),

---------------------------------------------------------------------
-- 🔥 TESTBENCH (clean RTL TB)
---------------------------------------------------------------------
s("tb",
fmt([[
module {}_tb;

    localparam int CLK_PERIOD = {};

    logic {};
    logic {};

    {}

    initial {} = 0;
    always #(CLK_PERIOD/2) {} = ~{};

    task automatic apply_reset;
        begin
            {} = 0;
            repeat (5) @(posedge {});
            {} = 1;
        end
    endtask

    {} dut (
        /*AUTOINST*/
    );

    initial begin
        apply_reset();
        $finish;
    end

endmodule
]],
{
    i(1, fname()),
    i(2, "10"),
    i(3, clk()),
    i(4, rst()),
    i(5, "// DUT signals"),
    i(6, clk()),
    i(7, clk()),
    i(8, clk()),
    i(9, rst()),
    i(10, clk()),
    i(11, rst()),
    i(12, fname()),
})),

---------------------------------------------------------------------
-- ⚙️ UVM-LITE INTERFACE
---------------------------------------------------------------------
s("uvmif",
fmt([[
interface {}_if (input logic {});

    logic [{}:0] data;
    logic        valid;
    logic        ready;

    clocking cb @(posedge {});
        input  ready;
        output data, valid;
    endclocking

endinterface
]],
{
    i(1, fname()),
    i(2, clk()),
    i(3, "DATA_WIDTH-1"),
    i(4, clk()),
})),

---------------------------------------------------------------------
-- ⚙️ DRIVER (UVM-lite)
---------------------------------------------------------------------
s("drv",
fmt([[
task automatic drive(input {}_if ifc);
    begin
        ifc.cb.valid <= 1'b1;
        ifc.cb.data  <= {};
        @(posedge {});
        ifc.cb.valid <= 1'b0;
    end
endtask
]],
{
    i(1, fname()),
    i(2, "'0"),
    i(3, clk()),
})),

})

