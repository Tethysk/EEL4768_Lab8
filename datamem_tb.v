//
// Name: Matthew Otto
// Last modified: 2017/07/23 (YYYY/MM/DD)
//
// Course: EEL4768
// Assignemnt: Lab8 - data memory testbench
//
//
// Module name: datamem_tb
// Module Desc: test bench for module datamem
// Internal parameters:
//		STARTADDR - 32-bit starting address for the memory, must correspond to UUT
//		LENGTH - number of bytes in the memory, must correspond to UUT
//
//
module datamem_tb;
parameter STARTADDR = 32'h1000_0000;
parameter LENGTH = 32'h0000_1000;

reg [31:0] wAddress; // machine input
reg [31:0] wDataIn;
reg wWE, wWriteByte, wWriteHalfWord, wClk;
wire[31:0] wData;    // machine output

reg [31:0] rightData; // correct output

reg [99:0] testvectors[0:100];	// array of test vector inputs
reg [10:0] errors;				// counts errors between UUT and TV known output
reg [10:0] vectornum;			// loop counter for processing the test vactors


// Connect UUT to test bench signals
datamem #(STARTADDR, LENGTH) uut(
.address       (wAddress),
.datain        (wDataIn),
.WE            (wWE),
.writebyte     (wWriteByte),
.writehalfword (wWriteHalfWord),
.clk           (wClk),
.data          (wData)
);


// Read test vector
initial begin
	$readmemh("testvec_lab8_datamem.txt", testvectors); //testvec is in hex
	vectornum = 0;
	errors = 0;
end

// Test Begins
always begin
	if (testvectors[vectornum][0] === 1'bX) begin    // X is the "End of File" indicator
		$display("%1d tests completed with %1d errors.", vectornum, errors);
		$finish;
	end
	
	{wAddress, wDataIn, wWE,wWriteByte, wWriteHalfWord, wClk, rightData} = testvectors[vectornum];
	#1  // must allow state machine time to run its behavioral code

		
	if (rightData !== wData) begin 
		errors = errors+1;	// found incorrect output
		$display("\nAddress:%h DataIn:%h writeEnable:%b writeByte:%b writeHalf:%b  CLK:%b");
		$display("incorrectly outputs Y=%h expected:%h \n",wData,rightData);
	end
	
	vectornum = vectornum+1; // increments loop counter
end
endmodule






