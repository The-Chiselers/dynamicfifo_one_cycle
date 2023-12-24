// Generated by CIRCT firtool-1.47.0
module DynamicFifo(
  input         clock,
                reset,
                io_push,
                io_pop,
  input  [63:0] io_dataIn,
  input  [7:0]  io_almostEmptyLevel,
                io_almostFullLevel,
  input  [63:0] io_ramDataOut,
  output [63:0] io_dataOut,
  output        io_empty,
                io_full,
                io_almostEmpty,
                io_almostFull,
                io_ramWriteEnable,
  output [7:0]  io_ramWriteAddress,
  output [63:0] io_ramDataIn,
  output        io_ramReadEnable,
  output [7:0]  io_ramReadAddress
);

  reg  [8:0] tail;
  reg  [8:0] head;
  reg  [8:0] count;
  wire       _io_empty_output = count == 9'h0;
  wire       _io_full_output = count == 9'h100;
  always @(posedge clock) begin
    if (reset) begin
      tail <= 9'h0;
      head <= 9'h0;
      count <= 9'h0;
    end
    else begin
      if (io_pop & ~_io_empty_output)
        tail <= tail + 9'h1;
      if (io_push & ~_io_full_output)
        head <= head + 9'h1;
      if (~(io_pop & io_push)) begin
        if (io_pop)
          count <= count - 9'h1;
        else if (io_push)
          count <= count + 9'h1;
      end
    end
  end // always @(posedge)
  assign io_dataOut = io_ramDataOut;
  assign io_empty = _io_empty_output;
  assign io_full = _io_full_output;
  assign io_almostEmpty = count <= {1'h0, io_almostEmptyLevel};
  assign io_almostFull = count >= {1'h0, io_almostFullLevel};
  assign io_ramWriteEnable = io_push;
  assign io_ramWriteAddress = head[7:0];
  assign io_ramDataIn = io_dataIn;
  assign io_ramReadEnable = io_pop;
  assign io_ramReadAddress = tail[7:0];
endmodule

