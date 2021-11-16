module gcd_ci(clk, reset, clk_en, start, dataa, datab, done, result);
    input logic clk;
    input logic reset;
    input logic clk_en;
    input logic start;
    input logic [31:0] dataa;
    input logic [31:0] datab;
    output logic done;
    output logic [31:0] result;

    logic unsigned [31:0] a;
    logic unsigned [31:0] b;

    // Done internal and edge detect is just done because
    // the custom instruction protocol wants a pulse.
    logic done_internal;
    edge_detect ED (clk, clk_en, reset, done_internal, done);

    always @(posedge clk)
    begin
        if (reset) begin
        done_internal <=  1'b0;
        a             <= 32'hDEADDEAD;
        b             <= 32'hDEADDEAD;
        result        <= 32'hDEADDEAD;
        end
        else begin
            if(clk_en) begin
                if (start) begin
                    done_internal <= 1'b0;
                    a             <= dataa;
                    b             <= datab;
                end
                else if (!done_internal) begin
                    if (b == 32'h0) begin
                        done_internal <= 1'b1;
                        result        <= a;
                    end
                    else if (a > b) begin
                        a <= a - b;
                    end
                    else begin
                        b <= b - a;
                    end
                    //$display("a:%0d, b:%0d result:%0h done:%0h",a, b, result, done);
                end
            end
        end
    end
endmodule

// Edge Detect
module edge_detect #(parameter RISING=1)
    (clk, clk_en, reset, in, e);
    input  clk;
    input  clk_en;
    input  reset;
    input  in;
    output e;

    reg tmp;

    always @(posedge clk)
    begin
        if (reset) // Synchronous reset when reset goes high
            tmp <= 1'b0;
        else begin
            if (clk_en)
                tmp <= in;
        end
    end

    assign e = RISING ? (~tmp & in) : (tmp & ~in);
endmodule