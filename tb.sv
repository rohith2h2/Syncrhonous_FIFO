//testbench for synchronous fifo32
` timescale 1ns / 1ps
`define clk_period 10

module synchronous_fifo_tb();
  //input signals
  reg clk,reset_signal;
  reg write_enable, read_enable;
  reg [31:0] data_input;
  //output signals
  wire [31:0] data_output;
  wire full_f , empty_f;
  //Instantiate the Unit under Test(UUT)
  synchronous_fifo uut(
  .clk(clk),
  .reset_signal(reset_signal),
  .write_enable(write_enable),
  .data_input(data_input),
  .read_enable(read_enable),
  .data_output(data_output),
  .full_f(full_f),
  .empty_f(empty_f)
  );
  initial clk = 1'b1; //initialized clock to high level
  
  always #(`clk_period/2) clk = ~clk;
  
  integer i; //defined integer i
  
  initial begin
    reset_signal = 1'b1; //reset signal is set high
    write_enable = 1'b0; //initially write enable is set low
    read_enable = 1'b0; //initially read enable is set low
    data_input = 32'b0;
    #(`clk_period);
    reset_signal = 1'b0; // reset is set to low level
    #(`clk_period);
    reset_signal = 1'b1; //reset is set high level
//write data : during write operation, write enable is made high to write and read is set to low
    write_enable = 1'b1;
    read_enable = 1'b0;
//for loop is used to write data with i into the fifo
    
    for(i=0; i<32; i=i+1)begin
      data_input = i;
      #(`clk_period);
    end
//after write operation we should see the full signal level as high
//read data : during read operation read enable is set to high
    write_enable = 1'b0;
    read_enable = 1'b1;
    
    for(i=0; i<32; i=i+1)begin
      #(`clk_period);
    end
//write data:
    
    write_enable = 1'b1;
    read_enable = 1'b0;
    for(i=0; i<32; i=i+1)begin
      data_input = i;
      #(`clk_period);
    end
    #(`clk_period);
    #(`clk_period);
    #(`clk_period);
    $finish;
  
  end

endmodule
