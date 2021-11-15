module gcd_ci(
    input clk,
    input reset,
    input clk_en,
    input start,
    input [31:0] dataa,
    input [31:0] datab,
    output reg done,
    output reg [31:0] result);

    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] tmp;
    reg done_internal;

    always @(posedge clk or posedge reset)
    begin
        if(reset == 1'b1) begin
        a             <=  1'b0;
        b             <=  1'b0;
        tmp           <=  1'b0;
        done_internal <=  1'b1;
        done          <=  1'b0;
        result        <= 32'hDEADBEEF;
        end
        else begin
            if (clk_en & start) begin
                a             <= dataa;
                b             <= datab;
                done_internal <= 1'b0;
                done          <= 1'b0;
                result        <= 32'h0;
            end
            else if (clk_en & !done_internal) begin
                if (a == 0) begin
                    done_internal <= 1'b1;
                    done          <= 1'b1;
                    result        <= b;
                end
                else if (b == 0) begin
                    done_internal <= 1'b1;
                    done          <= 1'b1;
                    result        <= a;
                end
                else begin
                    tmp = b;
                    b   = a % b;
                    a   = tmp;
                end
            end
            else if (clk_en) begin
                done <= 1'b0;
            end
        end
    end
endmodule