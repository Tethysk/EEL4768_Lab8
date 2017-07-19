//
// Name: Matthew Otto
// Last Modified: 2017/07/19
//
// Course: EEL4768
// Assignemnt: Lab8- Regfile testbench
//
module regfile_tb;
reg [4:0] wInput1;               // machine inputs 
reg [4:0] wInput2;
reg [4:0] wWriteReg;
reg [31:0] wWriteData;
reg wClk;
reg wWriteEN;

wire [31:0] wData1;             // machine outputs
wire [31:0] wData2;

reg [31:0] rightData1;          // correct outputs output
reg [31:0] rightData2;

reg [112:0] testvectors[0:112];  // [112:0] needs to be changed to [X:0] as X= truthTableLength-1 (DONE)
reg [10:0] errors;               // counts how many rows were incorrect
reg [10:0] vectornum;            // loop counterrows were incorrect

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
	$readmemb("testvec_lab8_regfile.txt", testvectors); //testvec is in binary
	vectornum = 0;
	errors = 0;
end

always begin
	if (testvectors[vectornum][0] === 1'bZ) begin    // Z is the "End of File" indicator
		$display("%1d tests completed with %1d errors.", vectornum, errors);
		$finish;
	end
	//wClk = 0;
	// input1_input2_writeReg_writeData_writeEN__rightData1_rightData2_clk
	{wInput1, wInput2, wWriteReg, wWriteData, wWriteEN, rightData1, rightData2, wClk} = testvectors[vectornum];
	//wClk = 1;
	#1  // must allow state machine time to run its behavioral code
	
	if (wData1 !== rightData1 || wData2 !== rightData2) begin 
		$display("\nClk:%b WriteEN:%b Input1:%h Input2:%h WriteReg:%h WriteData:%h", wClk, wWriteEN, wInput1, wInput2, wWriteReg, wWriteData);
		
		if (wData1 !== rightData1) begin
			$display("Incorrectly outputs Data1:%h expected:%h",wData1, rightData1);
			errors = errors+1;	// found incorrect output
		end
		
		if (wData2 !== rightData2) begin
			$display("Incorrectly outputs Data2:%h expected:%h",wData2, rightData2);
			errors = errors+1;	// found incorrect output
		end
	end
	
	vectornum = vectornum+1; // increments loop counter
end
endmodule


