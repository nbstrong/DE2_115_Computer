package gcd_pack;


endpackage

// Edge Detect
module edge_detect #(parameter RISING=1)
    (clk, clk_en, rst, in, e);
    input  clk;
    input  clk_en;
    input  rst;
    input  in;
    output e;

    reg tmp;

    always @(posedge clk)
    begin
        if (clk_en) begin
            if (rst) // Asynchronous reset when reset goes high
                tmp <= 1'b0;
            else
                tmp <= in;
        end
    end

    assign e = RISING ? (~tmp & in) : (tmp & ~in);
endmodule

// Set Clear FF
module set_reset
  (clk, clk_en, rst, en, clr, out);
    input  clk;
    input  clk_en;
    input  rst;
    input  en;
  	input  clr;
    output reg out;

    always @(posedge clk)
    begin
        if (clk_en) begin
            if (rst) // Asynchronous reset when reset goes high
                out <= 1'b0;
            else if (en)
                out <= 1'b1;
            else if (clr)
                out <= 1'b0;
        end
    end
endmodule