/***********************************************
* Author: Igor Semenov (is0031@uah.edu)
* Platform: Terasic DE2-115
* Date: 8/30/2019
* Description:
* The design implements the functionality described
* in CPE523_assignment_03.pdf
***********************************************/

module GcdPlus64Calculator(
    input logic clock,
    input logic reset,
    
    // Avalon-MM slave interface for accessing control-status registers
    input logic csr_read,
    input logic csr_write,
    input logic [2:0] csr_address,
    output logic [31:0] csr_readdata,
    input logic [31:0] csr_writedata
);

    typedef logic [63:0] Number_t;

    // A combinational function that returns x - y * 2^N using the
    // biggest N, but not big enough to produce a negative result.
    // For 64-bit version I am using only even values of N
    // to avoid using too much logic.
    function Number_t minDifference(input Number_t x, Number_t y);
        minDifference = 1'b0;
        for(int i = 2; i < $bits(Number_t) - 1; i += 2) begin
            if (x <= (y << i)) begin
                minDifference = x - (y << (i - 2));
                break;
            end
        end
    endfunction

    // Control-status registers:
    //     aReg: operand A
    //     bReg: operand B
    //     sReg: status register (contains 0 when computation is done)
    Number_t aReg, bReg;
    logic [31:0] sReg;

    always_ff @(posedge clock)
    begin
        if (reset) begin
            sReg <= 1'b0;
            
            // Registers aReg and bReg will be initialized by software
            // so I intentionally did not reset them
        end
        
        else begin
            // While sReg is set, keep doing computations
            if (sReg) begin
                if (aReg > bReg) aReg <= minDifference(aReg, bReg);
                else if (bReg > aReg) bReg <= minDifference(bReg, aReg);
                else sReg <= 1'b0;
            end
            
            // Write control-status registers
            // When computation is going, write is disabled
            else if (csr_write) begin
                case(csr_address)
                    // Status register is read-only
                    // 2'h0:
                
                    // Move data to aReg
                    3'h1: aReg[31:0] <= csr_writedata;
                    3'h2: aReg[63:32] <= csr_writedata;
                    
                    // Move data to bReg
                    3'h3: bReg[31:0] <= csr_writedata;
                    3'h4: begin
                        bReg[63:32] <= csr_writedata;
                        
                        // Writing to the higher part of 
                        // bReg starts the computation process
                        sReg <= 1'b1; 
                    end
                endcase
            end
            
            // Read is always possible
            if (csr_read) begin
                case(csr_address)
                    3'h0: csr_readdata <= sReg;
                    3'h1: csr_readdata <= aReg[31:0];
                    3'h2: csr_readdata <= aReg[63:32];
                    3'h3: csr_readdata <= bReg[31:0];
                    3'h4: csr_readdata <= bReg[63:32];
                    default: csr_readdata <= 32'hdeadbeef;
                endcase
            end
        end
    end
    
endmodule