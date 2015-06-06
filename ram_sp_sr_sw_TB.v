`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:28:41 06/05/2015
// Design Name:   ram_sp_sr_sw
// Module Name:   /home/sperez/cpu1515/ram00/ram_sp_sr_sw_TB.v
// Project Name:  ram00
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_sp_sr_sw
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ram_sp_sr_sw_TB;

	// Inputs
	reg clk;
	reg [4:0] address;
	reg cs;
	reg we;
	reg oe;

	// Bidirs
	wire [4:0] mdata;
	reg [4:0] wdata;
	
	integer i;

	// si no es escritura mdata se pone en 3er estado y la ram es la fuente para el bus
	assign mdata=(we&~oe)?wdata:5'bz;
	// la escritura requiere we=1 y oe=0 y poner el dato en el bus mdata
	//		en este caso la ram pone en 3er. edo el bus y este modulo usa el bus
	
	// Instantiate the Unit Under Test (UUT)
	ram_sp_sr_sw uut (
		.clk(clk), 
		.address(address), 
		.data(mdata), 
		.cs(cs), 
		.we(we), 
		.oe(oe)
	);

	initial forever #20 clk=~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		cs = 1;
		we = 0;
		oe = 1;
		// lectura de la ram
		for(i=0; i<32; i=i+1) begin
			#18 address=i;
				# 22;
		end
        
		// escribir la localidad 11 coon un 15.
		#18 we=1;
			oe=0;
			address=11;
			wdata=15;
		#4 we=0; // regreso a lectura
			oe=1; // mdata en 3er. estado por la ram y por el assign en este modulo
					// hasta la prox. subida del reloj
			// a partir de este punto se esta leyendo la localidad 11 (debe ser un 15 en mdata)
	end
      
endmodule

