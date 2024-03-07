module synchronous_fifo(
  input clk, //clock input
  input reset_signal,
  input write_enable,
  input [31:0] data_input, //32-bit data input
  output full_f, //flag to indicate that the FIFO memory is full
  input read_enable,
  output reg [31:0] data_output, //32-bit data output
  output empty_f //flag to indicate that the FIFO memory is Empty

);
  
  parameter DEPTH = 32; //DEPTH value is the no of bits that can be allotted in fifo
  reg [31:0] mem [0 : DEPTH-1];
  reg [5:0] write_pointer; //defined write pointer
  reg [5:0] read_pointer; //defined read pointer
  reg [6:0] count;
  assign full_f = (count == DEPTH) ? 1'b1:1'b0; // if count is equal to depth, full_f will be 1 else 0
  assign empty_f = (count == 0) ?1'b1:1'b0;
//------this block handles the write process onto fifo------
  
  always @(posedge clk or negedge reset_signal) begin
    if(!reset_signal) begin
      write_pointer <= 0;
    end 
    else begin
      if(write_enable == 1) begin
        mem[write_pointer] <= data_input; //data is written onto fifo
        write_pointer <= write_pointer + 1; //increases write pointer
      end
      end
    end
//-------this block handles the read process----------
  always @(posedge clk or negedge reset_signal) begin
    if(!reset_signal) begin
      read_pointer <= 0;
    end else begin
      if(read_enable == 1) begin
        data_output = mem[read_pointer];
        read_pointer <= read_pointer + 1;
      end
      end
    end
//---------this block handles the count----------------
  always @(posedge clk or negedge reset_signal) begin
    if(!reset_signal) begin
      count <= 6'd0;
    end else begin
      case ({write_enable , read_enable})
        2'b10: count <= count+1;
        2'b01: count <= count -1;
        2'b11: count <= count;
        2'b00: count <= count;
        default: count <= count;
      endcase
        end
    end
endmodule
