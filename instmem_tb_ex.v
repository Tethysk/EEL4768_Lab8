// Author: David Foster
// Last modified: 3/29/2017
// Module name: instmem_tb_ex
// Module Desc: test bench for module instmem
// Internal parameters:
//		STARTADDR - 32-bit starting address for the memory, must correspond to UUT
//		LENGTH - number of bytes in the memory, must correspond to UUT
//
//

module instmem_tb_ex;
parameter STARTADDR = 32'h0040_0000;
parameter LENGTH = 32'h0000_1000;

reg [31:0] addr;
wire[31:0] data;

reg [63:0] testvectors[0:100];	// array of test vector inputs
reg [10:0] errors;				// counts errors between UUT and TV known output
reg [10:0] vectornum;			// loop counter for processing the test vactors

reg [31:0] i;					// loop counter to initialize inst memory


// Demonstrates a loop for initializing the first 100 location to specific values
initial begin
	for (i=0; i< 100; i=i+1) begin
		uut.memory[STARTADDR+i] = i%256;  // can only store 0-255 in a byte
		
		$display("Address: %h Contents: %h", STARTADDR+i, uut.memory[STARTADDR+i]);
	end
end



instmem #(STARTADDR, LENGTH) uut(
.addr (addr),
.data (data)
);
endmodule