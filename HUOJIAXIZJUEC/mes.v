module LCD_1602(clk,LCD_EN,RS,RW,DB8,one_wire,rst);
 
	input   clk,rst;        
	output  LCD_EN;			
	output  RS;				
	output  RW;				
	output  [7:0] DB8; 				
	inout 	one_wire;		
 
	reg    		RS;
	reg			LCD_EN_Sel;
	reg [7:0] 	DB8;
	reg [127:0]	data_row1;
	reg [127:0]	data_row2;
 
	reg	[7:0]	result_unit;
	reg	[7:0] 	result_decade;
	reg [7:0]   result_hundred;
	reg [7:0]   result_dec;
	reg [7:0]	result_dec2;
	reg [7:0]	result_dec3;
	reg [7:0] 	result_dec4;
	reg [7:0]	sign;
 
	reg [3:0] num_unit;
	reg [3:0] num_decade;
	reg [3:0] num_hundred;
	reg [3:0] num_dec;
	reg [3:0] num_dec2;
	reg [3:0] num_dec3;
	reg [3:0] num_dec4;						
 
	reg[19:0] cnt_ref;						
	reg ref;								
 
	always@(posedge clk_2ms)				
		begin			
			if(cnt_ref==220) 
				begin
					cnt_ref<=0;
					ref<=1;
					ref<=0;	
				end
		else 
			begin
				cnt_ref<=cnt_ref+1;
				ref<=1;
			end	
		end
 
	always@(*)								
		begin	
			case(num_unit)					
				4'd0:result_unit<=8'b00110000;
				4'd1:result_unit<=8'b00110001;
				4'd2:result_unit<=8'b00110010;
				4'd3:result_unit<=8'b00110011;
				4'd4:result_unit<=8'b00110100;
				4'd5:result_unit<=8'b00110101;
				4'd6:result_unit<=8'b00110110;
				4'd7:result_unit<=8'b00110111;
				4'd8:result_unit<=8'b00111000;
				4'd9:result_unit<=8'b00111001;
			 default:result_unit<=result_unit;
			endcase
 
			case(num_decade)				
				4'd0:result_decade<=8'b00110000;
				4'd1:result_decade<=8'b00110001;
				4'd2:result_decade<=8'b00110010;
				4'd3:result_decade<=8'b00110011;
				4'd4:result_decade<=8'b00110100;
				4'd5:result_decade<=8'b00110101;
				4'd6:result_decade<=8'b00110110;
				4'd7:result_decade<=8'b00110111;
				4'd8:result_decade<=8'b00111000;
				4'd9:result_decade<=8'b00111001;
			 default:result_decade<=result_decade;
			endcase
 
			case(num_hundred)				
				4'd0:result_hundred<=8'b00110000;
				4'd1:result_hundred<=8'b00110001;
				4'd2:result_hundred<=8'b00110010;
				4'd3:result_hundred<=8'b00110011;
				4'd4:result_hundred<=8'b00110100;
				4'd5:result_hundred<=8'b00110101;
				4'd6:result_hundred<=8'b00110110;
				4'd7:result_hundred<=8'b00110111;
				4'd8:result_hundred<=8'b00111000;
				4'd9:result_hundred<=8'b00111001;
			 default:result_hundred<=result_hundred;
			endcase	
 
			case(num_dec)					
				4'd0:result_dec<=8'b00110000;
				4'd1:result_dec<=8'b00110001;
				4'd2:result_dec<=8'b00110010;
				4'd3:result_dec<=8'b00110011;
				4'd4:result_dec<=8'b00110100;
				4'd5:result_dec<=8'b00110101;
				4'd6:result_dec<=8'b00110110;
				4'd7:result_dec<=8'b00110111;
				4'd8:result_dec<=8'b00111000;
				4'd9:result_dec<=8'b00111001;
			 default:result_dec<=result_dec;
			endcase		
 
			case(num_dec4)					
				4'd0:result_dec4<=8'b00110000;
				4'd1:result_dec4<=8'b00110001;
				4'd2:result_dec4<=8'b00110010;
				4'd3:result_dec4<=8'b00110011;
				4'd4:result_dec4<=8'b00110100;
				4'd5:result_dec4<=8'b00110101;
				4'd6:result_dec4<=8'b00110110;
				4'd7:result_dec4<=8'b00110111;
				4'd8:result_dec4<=8'b00111000;
				4'd9:result_dec4<=8'b00111001;
			 default:result_dec4<=result_dec4;
			endcase	
 
			case(num_dec2)					
				4'd0:result_dec2<=8'b00110000;
				4'd1:result_dec2<=8'b00110001;
				4'd2:result_dec2<=8'b00110010;
				4'd3:result_dec2<=8'b00110011;
				4'd4:result_dec2<=8'b00110100;
				4'd5:result_dec2<=8'b00110101;
				4'd6:result_dec2<=8'b00110110;
				4'd7:result_dec2<=8'b00110111;
				4'd8:result_dec2<=8'b00111000;
				4'd9:result_dec2<=8'b00111001;
			 default:result_dec2<=result_dec2;
			endcase	
 
			case(num_dec3)					
				4'd0:result_dec3<=8'b00110000;
				4'd1:result_dec3<=8'b00110001;
				4'd2:result_dec3<=8'b00110010;
				4'd3:result_dec3<=8'b00110011;
				4'd4:result_dec3<=8'b00110100;
				4'd5:result_dec3<=8'b00110101;
				4'd6:result_dec3<=8'b00110110;
				4'd7:result_dec3<=8'b00110111;
				4'd8:result_dec3<=8'b00111000;
				4'd9:result_dec3<=8'b00111001;
			 default:result_dec3<=result_dec3;
			endcase	
		end		 
 
 
	reg [15:0]count;
	reg clk_2ms;
	always @ (posedge clk)
		begin
			if(count == 16'd12_000)
				begin
					count <= 16'b1;
					clk_2ms <= ~clk_2ms;
				end
			else  
				count <= count + 1'b1;
		end

 
	reg     [127:0] Data_Buf;   					
	reg     [4:0] disp_count;						
	reg     [3:0] state;							
 
	parameter   Clear_Lcd = 4'b0000;  				 
	parameter	Set_Disp_Mode = 4'b0001; 			
	parameter	Disp_On = 4'b0010;			 		
	parameter	Shift_Down = 4'b0011;  				
	parameter	Write_Addr = 4'b0100;   		
	parameter	Write_Data_First = 4'b0101; 		   
	parameter	Write_Data_Second = 4'b0110; 				
	assign  RW = 1'b0;  							
	assign  LCD_EN = LCD_EN_Sel ? clk_2ms : 1'b0;	
 
 

	always @(posedge clk_2ms  or negedge rst  or negedge ref)
		begin
   
 
		if(!rst || !ref)
			begin
				state <= Clear_Lcd;  					   
				RS <= 1'b1;          					                     
				DB8 <= 8'b0;         					
				LCD_EN_Sel <= 1'b0;  					
				disp_count <= 5'b0;					
					data_row1 <= {   					
									8'b01010011,    	
									8'b01010100,		
									8'b01000101,		
									8'b01010000,		
									8'b00100000,		
									8'b01000110,		
									8'b01010000,		
									8'b01000111,		
									8'b01000001,		
									8'b00100000,		
									8'b00100000,			
									8'b00100000,		
									8'b00100000,		
									8'b00100000,      	      
									8'b00100000,		
									8'b00100000			
								};
					data_row2 <= {	8'b00100000,		
									8'b00100000,		
									8'b01010100, 		
									8'b01100101,		
									8'b01101101, 		
									8'b00111010,		
									sign, 		
									result_unit,		
									result_decade,         
									result_hundred,        
									8'b00101110,		
									result_dec,        
									result_dec2,    
									result_dec3,
									8'hdf,				
									8'b01000011
 
								};
						end
			else 
				begin
					case(state)  
     	
 
				    Clear_Lcd : begin LCD_EN_Sel <= 1'b1;			
									  RS <= 1'b0;					
									  DB8 <= 8'b00000001;  		
								      state <= Set_Disp_Mode; end
				Set_Disp_Mode : begin DB8 <= 8'b00111000;  		 	
									  state <= Disp_On;       end
					  Disp_On : begin DB8 <= 8'b00001100;   		
									  state <= Shift_Down;	  end
				   Shift_Down : begin DB8 <= 8'b00000110;    		    
									  state <= Write_Addr;    end
 
	
 
				   Write_Addr : begin RS 		<= 1'b0;			
									  DB8 		<= 8'b10000000;        
									  Data_Buf 	<= data_row1;     	
								      state 	<= Write_Data_First; 	end								
			 Write_Data_First : begin 									
									if(disp_count == 16)    		
										begin
										RS 		<= 1'b0;			
										DB8 	<= 8'b11000000;    
										disp_count <= 5'b0; 		
										Data_Buf   <= data_row2;	
										state  	   <= Write_Data_Second;end  
									else							
										begin
										RS <= 1'b1;    				
										DB8 <= Data_Buf[127:120];
										Data_Buf <= (Data_Buf << 8);
										disp_count <= disp_count + 1'b1;
										state <= Write_Data_First;		end end
			Write_Data_Second : begin						
									if(disp_count == 16)
										begin
											RS <= 1'b0;				
											DB8 <= 8'b10000000;     
											disp_count <= 5'b0; 
											state <= Write_Addr;   
										end
									else
										begin
											RS <= 1'b1;
											DB8 <= Data_Buf[127:120];
											Data_Buf <= (Data_Buf << 8);
											disp_count <= disp_count + 1'b1;
											state <= Write_Data_Second; 
										end end

					  default :  state <= Clear_Lcd; 
				endcase 
			end
		end
 

 
 
 
wire clk_in;
wire rst_n_in;
wire [15:0] data_out; 	
wire tem_flag=data_out[15:11]?1'b0:1'b1;
wire [10:0] tem_code=tem_flag?data_out[10:0]:(~data_out[10:0])+1'b1; 
wire [20:0] tem_data=tem_code*625;
reg [27:0] bcd_code;
DS18B20Z DS18B20Z_uut
(    
.one_wire(one_wire),
.clk_in(clk),
.rst_n_in(rst),
.data_out(data_out)
);
 
 
 
	reg	[48:0] shift_reg;   
always@(posedge clk or negedge rst)begin      
 
	shift_reg= {28'h0,tem_data}; 
 
	if(!rst) bcd_code = 0;      
	else 
		begin         
		repeat(21)
			begin                                
				if (shift_reg[24:21] >= 5) shift_reg[24:21] = shift_reg[24:21] + 2'b11;
				if (shift_reg[28:25] >= 5) shift_reg[28:25] = shift_reg[28:25] + 2'b11;
				if (shift_reg[32:29] >= 5) shift_reg[32:29] = shift_reg[32:29] + 2'b11;
				if (shift_reg[36:33] >= 5) shift_reg[36:33] = shift_reg[36:33] + 2'b11;
				if (shift_reg[40:37] >= 5) shift_reg[40:37] = shift_reg[40:37] + 2'b11;
				if (shift_reg[44:41] >= 5) shift_reg[44:41] = shift_reg[44:41] + 2'b11;
				if (shift_reg[48:45] >= 5) shift_reg[48:45] = shift_reg[48:45] + 2'b11;
				if (tem_flag==0) sign<=8'b00101101;
				if (tem_flag==1) sign<=8'b00100000;
				shift_reg = shift_reg << 1; 
			end         
				bcd_code=shift_reg[48:21];   
 
		 num_unit	<=	bcd_code[27:24];
		 num_decade	<=	bcd_code[23:20];
		 num_hundred<=	bcd_code[19:16];
		 num_dec	<=	bcd_code[15:12];
		 num_dec2	<=  bcd_code[11:8];
		 num_dec3	<=  bcd_code[7:4];
		 num_dec4	<=  bcd_code[3:0];
 
 
	end  
end
 
endmodule
