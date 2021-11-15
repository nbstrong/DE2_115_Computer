/***********************************************
* Author: Igor Semenov (is0031@uah.edu)
* Platform: Terasic DE2-115
* Date: 10/27/2019
* Description:
*     
*     
*     
***********************************************/
module SwapInstruction(
    input logic [31:0] dataa,
    output logic [31:0] result
);

    assign result = {dataa[7:0], dataa[15:8], dataa[23:16], dataa[31:24]};
    
endmodule