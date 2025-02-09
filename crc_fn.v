

module crc_fn(msg,crc_out,trans_bit,flag,sel,rst);
input [7:0] msg;//stores the msg bits
input sel;//sel = 1 transmit sel=0 recieve
input rst;
reg rst1,rst2;
//input [32:0] key;//key stores the poly
output [31:0] crc_out;//stores redundant bits
output [39:0] trans_bit;//transmitted bit
//input [39:0] rec_bit;//recieved bit
output flag;//flag=1 for correct crc else 0
wire [6:0] s0,s1,s2,s3,s4,s5,s6;
//wire [6:0] hex0;//seven segment regs
reg [31:0] crc_out;
wire[31:0] c_out;
reg [39:0] trans_bit,shift2,shift,shift1;
reg [39:0] t_bit;
reg flag;
wire f;
initial
begin
shift2={msg,32'b0};//concat of 0
end
  
always@(rst)
begin

if (rst)
begin
if (sel)
begin
crc_out=crc_gen(shift2);
trans_bit<={{msg},{crc_out}};
//flag=crc_check(t_bit);

end
else
begin
t_bit<=trans_bit;
flag=crc_check(t_bit);
end
end
end


function [32:0] crc_gen;
input [39:0] shift;
integer i;
reg [32:0] key;
begin
key=33'b100000100110000010001110110110111;
for(i=0;i<8;i=i+1)
begin
if(shift[39]==1)//if msb==1 xor
begin
shift[39:7]=shift[39:7]^key;
shift=shift<<1;
end
else//else shift
begin
shift=shift<<1;
end
end
crc_gen=shift[39:8];
end
endfunction

function crc_check;
input [39:0] shift1;
integer i; 
reg[32:0] key;
begin
key=33'b100000100110000010001110110110111;
for(i=0;i<8;i=i+1)
begin
if(shift1[39]==1)//if msb==1 xor
begin
shift1[39:7]=shift1[39:7]^key;
shift1=shift1<<1;
end
else//else shift
begin
shift1=shift1<<1;
end
end
if(shift1[39:8]==32'b0)
begin
crc_check=1;
end
else
begin
crc_check=0;
end
end
endfunction
BCD1 b0(.hex0(s0),.sw(crc_gen[3:0]));
BCD1 b1(.hex0(s1),.sw(crc_gen[7:4]));
BCD1 b2(.hex0(s2),.sw(crc_gen[11:8]));
BCD1 b3(.hex0(s3),.sw(crc_gen[15:12]));
BCD1 b4(.hex0(s4),.sw(crc_gen[19:16]));
BCD1 b5(.hex0(s5),.sw(crc_gen[23:20]));
BCD1 b6(.hex0(s6),.sw(crc_gen[27:24]));



endmodule

module BCD1(hex0,sw);
input [3:0] sw;
output [6:0] hex0;
reg [6:0] hex0;
// seg = {g,f,e,d,c,b,a};
// 0 is on and 1 is off

always @ (sw)
case (sw)
		4'h0: hex0 = 7'b1000000;
		4'h1: hex0 = 7'b1111001; 	// ---a----
		4'h2: hex0=  7'b0100100; 	// |	  |
		4'h3: hex0 = 7'b0110000; 	// f	  b
		4'h4: hex0 = 7'b0011001; 	// |	  |
		4'h5: hex0 = 7'b0010010; 	// ---g----
		4'h6: hex0 = 7'b0000010; 	// |	  |
		4'h7: hex0 = 7'b1111000; 	// e	  c
		4'h8: hex0 = 7'b0000000; 	// |	  |
		4'h9: hex0 = 7'b0011000; 	// ---d----
		4'ha: hex0 = 7'b0001000;
		4'hb: hex0 = 7'b0000011;
		4'hc: hex0 = 7'b1000110;
		4'hd: hex0 = 7'b0100001;
		4'he: hex0 = 7'b0000110;
		4'hf: hex0 = 7'b0001110;
endcase

endmodule

/*module top_tb();
reg [7:0] msg;//stores the msg bits
reg rst;
reg sel;
//reg [32:0] key;//key stores the poly
//reg [39:0] rec_bit;
wire [31:0] crc_out;//stores redundant bits
wire [39:0] trans_bit;//transmitted bit
wire flag;
top t1(.msg(msg),.crc_out(crc_out),.trans_bit(trans_bit),.flag(flag),.rst(rst),.sel(sel));
initial
begin
$monitor("the redundant bit =%b,the crc generated msg bit =%b crc passed =%b",crc_out,trans_bit,flag);

msg=8'b11101111;rst=1'b1;sel=1'b1;//key=33'b100000100110000010001110110110111;
#15 rst=1'b1;
#20 sel=1'b0;rst=1'b0;
#20 sel=1'b0;rst=1'b1;

end
/*initial
begin
$monitor(" crc passed =%b",flag);
#20 sel=1'b0;rst=1'b0;
end
endmodule*/