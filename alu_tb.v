//
// Name: Matthew Otto
// Last Modified: 2017/07/25
//
// Course: EEL4768
// Assignemnt: Lab8- ALU testbench
//
module alu_tb;
reg [31:0] wInA;               // machine inputs 
reg [31:0] wInB;
reg [3:0]  wOperation;

wire [31:0] wResult;             // machine outputs
wire wZero;

reg [31:0] rightResult;          // correct outputs output
reg [3:0] rightZero; //only going to take [3] form it

reg [103:0] testvectors[0:112];  // [103:0] needs to be changed to [X:0] as X= truthTableLength-1 (DONE!)
reg [10:0] errors;               // counts how many rows were incorrect
reg [10:0] vectornum;            // loop counterrows were incorrect

// Connect UUT to test bench signals
alu uut(
.inA        (wInA),
.inB        (wInB),
.operation  (wOperation),
.result     (wResult),
.zero       (wZero)
);

// Remember to take a dump
initial  begin
    $dumpfile ("lab8_alu.vcd"); 
	$dumpvars; 
end 

initial begin
	$readmemh("testvec_lab8_alu.txt", testvectors); //testvec is in hex
	vectornum = 0;
	errors = 0;
end

always begin
	if (testvectors[vectornum][0] === 1'bZ) begin    // Z is the "End of File" indicator
		$display("%1d tests completed with %1d errors.", vectornum, errors);
		$finish;
	end
	// inA_inB_operation_rightResult_rightZero
	{wInA, wInB, wOperation, rightResult, rightZero} = testvectors[vectornum];
	#1  // must allow state machine time to run its behavioral code
	
	if (wResult !== rightResult || wZero !== rightZero[0]) begin 
		$display("\nInputA:%h InputB:%h Operation:%b",wInA, wInB, wOperation);
		
		if (wResult !== rightResult) begin
			$display("Incorrectly outputs Result:%h expected:%h",wResult, rightResult);
			errors = errors+1;	// found incorrect output
		end
		
		if (wZero !== rightZero[0]) begin
			$display("Incorrectly outputs Zero:%b expected:%h",wZero, rightZero);
			errors = errors+1;	// found incorrect output
		end
	end
	
	vectornum = vectornum+1; // increments loop counter
end
endmodule


