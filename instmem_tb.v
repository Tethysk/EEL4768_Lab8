//
// Name: Matthew Otto
// Last modified: 2017/07/18 (YYYY/MM/DD)
//
// Course: EEL4768
// Assignemnt: Lab8 - instruction memory testbench
//
//
// Module name: instmem_tb
// Module Desc: test bench for module instmem
// Internal parameters:
//		STARTADDR - 32-bit starting address for the memory, must correspond to UUT
//		LENGTH - number of bytes in the memory, must correspond to UUT
//
//
module instmem_tb;
parameter STARTADDR = 32'h0040_0000;
parameter LENGTH = 32'h0000_1000;

reg [31:0] wAddr; // machine input
wire[31:0] wData; // machine output

reg [31:0] rightData; // correct output

reg [63:0] testvectors[0:100];	// array of test vector inputs
reg [10:0] errors;				// counts errors between UUT and TV known output
reg [10:0] vectornum;			// loop counter for processing the test vactors

reg [31:0] i;					// loop counter to initialize inst memory


// Connect UUT to test bench signals
instmem #(STARTADDR, LENGTH) uut(
.addr (wAddr),
.data (wData)
);


// Fills entire memory array to LENGTH
initial begin
	for (i=0; i< LENGTH; i=i+1) begin
		uut.memory[STARTADDR+i] = i%256;  // can only store 0-255 in a byte
		
		//$display("Address: %h Contents: %h", STARTADDR+i, uut.memory[STARTADDR+i]);
	end
end


// Read test vector
initial begin
	$readmemh("testvec_lab8_instmem.txt", testvectors); //testvec is in hex
	vectornum = 0;
	errors = 0;
end

// Test Begins
always begin
	if (testvectors[vectornum][0] === 1'bX) begin    // X is the "End of File" indicator
		$display("%1d tests completed with %1d errors.", vectornum, errors);
		$finish;
	end
	
	{wAddr, rightData} = testvectors[vectornum];
	#1  // must allow state machine time to run its behavioral code

	//$display("\nAddress:%h Data:%h Output:%h",wAddr, wData, rightData);
	
	if (rightData !== wData) begin 
		errors = errors+1;	// found incorrect output
		$display("incorrectly outputs Y=%h expected:%h \n",wData,rightData);
	end
	
	vectornum = vectornum+1; // increments loop counter
end
endmodule






