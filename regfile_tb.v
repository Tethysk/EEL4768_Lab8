// Name: Matthew Otto
// Last Modified: 2017/07/19
//
// Course: EEL4768
// Assignemnt: Lab8- Regfile testbench
//
module regfile_tb;
reg [4:0] wInput1;             // machine inputs 
reg [4:0] wInput2;
reg [4:0] wWriteReg;
reg [31:0] wWriteData;
reg wClk,wWriteEN;
wire [31:0] wData1;            // machine output
wire [31:0] wData2;
reg [90:0] testvectors[0:100]; // [90:0] needs to be changed to [X:0] as X= truthTableLength-1 (DONE)
reg [10:0] errors;             // counts how many rows were incorrect
reg [10:0] vectornum;          // loop counterrows were incorrect
reg [31:0] rightPC;            // truth table expected output

// Connect UUT to test bench signals
regfile uut( // sets 2 paramaters in order
.input1    (wInput1),
.input2    (wInput2),
.writeReg  (wWriteReg),
.writeData (wWriteData),
.writeEN   (wWriteEN),
.clk       (wClk),
.data1     (wData1),
.data2     (wData2)
);

// Remember to take a dump
initial  begin
    $dumpfile ("lab8_regfile.vcd"); 
	$dumpvars; 
end 

initial begin
	$readmemh("testvec_lab8_regfile.txt", testvectors); //testvec is in hex
	vectornum = 0;
	errors = 0;
end

always begin
	if (testvectors[vectornum][0] === 1'bZ) begin    // Z is the "End of File" indicator
		$display("%1d tests completed with %1d errors.", vectornum, errors);
		$finish;
	end
	wClk = 0;
	{wReset, wNextPC, rightPC} = testvectors[vectornum];
	wClk = 1;
	#1  // must allow state machine time to run its behavioral code
	if (rightPC !== wPC) begin 
		errors = errors+1;	// found incorrect output
		$display("Reset:%b NextPC:%h", wReset, wNextPC);
		$display("Incorrectly outputs Y=%h expected:%h \n",wPC, rightPC);
	end
	vectornum = vectornum+1; // increments loop counter
end
endmodule


