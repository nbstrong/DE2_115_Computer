/***********************************************
* Author: Igor Semenov (is0031@uah.edu)
* Platform: Terasic DE2-115
* Date: 10/27/2019
* Description:
*     Example of a purely combinational
*     custom instruction for Nios II.
*     This instruction swaps all bytes
*     in a word such that a Little Endian
*     number can be converter to a Big Endian
*     one or vise versa.
***********************************************/
module SwapInstruction(
    // Input operand
    input logic [31:0] dataa,
    
    // Result of swapping
    output logic [31:0] result
);

    assign result = {dataa[7:0], dataa[15:8], dataa[23:16], dataa[31:24]};
    
endmodule