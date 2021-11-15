import gcd_pack::*;

module gcd_ci(
    input clk,
    input reset,
    input clk_en,
    input start,
    input [31:0] dataa,
    input [31:0] datab,
    output reg done,
    output reg [31:0] result);

    logic [31:0] tmp, b, a;
    logic start_int;

    edge_detect ED (clk, clk_en, reset, start, start_int);

    always @(posedge clk or posedge reset)
    begin
        if(reset) begin
            a      <=  1'b0;
            b      <=  1'b0;
            tmp    <=  1'b0;
            done   <=  1'b1;
            result <= 31'b0;
        end
        else if (clk_en) begin
            if (start_int) begin
                a       <= dataa;
                b       <= datab;
                done    <= 1'b0;
            end
            else if (!done) begin
                if (a == 0) begin
                    done   <= 1'b1;
                    result <= b;
                end
                else if (b == 0) begin
                    done   <= 1'b1;
                    result <= a;
                end
                else begin
                    tmp = b;
                    b   = a % b;
                    a   = tmp;
                end
            end
        end
    end
endmodule