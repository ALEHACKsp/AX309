`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    key_dect 
//////////////////////////////////////////////////////////////////////////////////
module key_dect(
	input clk50M,
	input reset_n,
	input  key1,

 	output reg record_en,
	output reg play_en,  	
	output reg sdr_raddr_set,
	output reg sdr_waddr_set

    );

reg [15:0] down_counter;                 //�������¼Ĵ���
reg [15:0] up_counter;                 //�����ɿ��Ĵ���

//�������´�������
always @(posedge clk50M)
begin
   if (reset_n==1'b0) begin
	    down_counter<=0;
		 sdr_waddr_set<=1'b0;
		 record_en<=1'b0; 
	end
	else begin
	    if (key1==1'b1) begin                             //�����ťû�а��£��Ĵ���Ϊ0
	       down_counter<=0;
		    record_en<=1'b0;
          sdr_waddr_set<=1'b0;  
       end 			 
	    else if ((key1==1'b0)& (down_counter<=16'hc350)) begin            
         sdr_waddr_set<=1'b1;                     //sdr��д��ַ��λ           
			down_counter<=down_counter+1'b1;         //�����ť���²�����,����  
			record_en<=1'b0;
		 end	
  	    else if (down_counter==16'hc351) begin                //��ť�Ѱ��£���ʼ¼��   
			down_counter<=down_counter;
		   record_en<=1'b1;
         sdr_waddr_set<=1'b0;  			
       end
   end 
end

//�����ɿ���������
always @(posedge clk50M)
begin
   if (reset_n==1'b0) begin
	    up_counter<=0;
		 sdr_raddr_set<=1'b0;
		 play_en<=1'b0; 
	end
	else begin
	    if (key1==1'b0) begin                              //�����ťû���ɿ����Ĵ���Ϊ0
	       up_counter<=0;
			 play_en<=1'b0;
          sdr_raddr_set<=1'b0;    
		 end
	    else if ((key1==1'b1)& (up_counter<=16'hc350)) begin            
         sdr_raddr_set<=1'b1;                     //sdr��д��ַ��λ           
			up_counter<=up_counter+1'b1;             //�����ť���²�����,����  
			play_en<=1'b0;
		 end
       else if (up_counter==16'hc351) begin                 //��ť���ɿ�����ʼ����
			up_counter<=up_counter;	
			play_en<=1'b1;	
         sdr_raddr_set<=1'b0;                               //ddr��д��ַ��λ 			
		 end
    end 
end

endmodule