module rotator (output[7:0] out, input[7:0] in, input direction);
    assign out[7] = (direction)?in[0]:in[6];
    assign out[6] = (direction)?in[7]:in[5];
    assign out[5] = (direction)?in[6]:in[4];
    assign out[4] = (direction)?in[5]:in[3];
    assign out[3] = (direction)?in[4]:in[2];
    assign out[2] = (direction)?in[3]:in[1];
    assign out[1] = (direction)?in[2]:in[0];
    assign out[0] = (direction)?in[1]:in[7];
endmodule
