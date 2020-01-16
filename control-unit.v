`include "ALU.v"
`include "PC.v"
`include "data-memory.v"
`include "instruction-memory.v"
`include "internal-registers.v"
`include "clock.v"

module CU (output[7:0] pc, output[15:0] resultALU, output reg[3:0] SREG, input clk);
    wire[5:0] opcode;
    reg[2:0] state, regNum;
    reg[7:0] immediateValue;

    assign pc = pcCurrent;
    assign resultALU = {mulHighALU, resultALULow};

    assign opcode = instruction[15:10];

    //PC
    wire[7:0] pcNext;
    reg[7:0] pcCurrent, jumpLine;
    reg jump, hold;

    //GPR
    wire[7:0] regAData, regBData;
    reg[7:0] regCIn, mulHighIn;
    reg[2:0] regANum, regBNum, regCNum;
    reg readEn, writeEn;

    //ALU
    wire[7:0] mulHighALU, resultALULow;
    wire[3:0] aluSREG;
    reg[7:0] operandA, operandB;
    reg[3:0] aluFSL;

    //Instruction Memory
    wire[15:0] instruction;

    //Data Memory
    wire[7:0] memOut;
    reg[7:0] memIn;
    reg[2:0] lineNumber;
    reg memRead, memWrite;

    dataMemory dMEM (memOut, memIn, lineNumber, memRead, memWrite, clk);
    instructionMemory iMEM (instruction, pcCurrent);
    ALU alu (mulHighALU, resultALULow, aluSREG, operandA, operandB, aluFSL);
    GPRs registerFile (regAData, regBData, readEn, writeEn, regCIn, mulHighIn, regANum, regBNum, regCNum, clk);
    PC programCounter (pcNext, pcCurrent, jumpLine, jump, hold, clk);

    always @ (posedge clk) begin
        case(opcode[5:4])
            2'b00:  begin //ALU
                regANum = instruction[9:7];
                regBNum = instruction[6:4];
                regCNum = instruction[3:1];
                aluFSL = opcode[3:0];
                case(state)
                    3'b000: begin      //read both operands from instruction
                      hold=1;
                      readEn=1;
                      writeEn=0;
                      state=state+1;
                    end
                    3'b001: begin      //set up ALU parameters
                      readEn=0;
                      operandA=regAData;
                      operandB=regBData;
                      state=state+1;
                    end
                    3'b010: begin      //allow ALU to process
                      regCIn=resultALULow;
                      mulHighIn=mulHighALU;
                      state=state+1;
                    end
                    3'b011: begin        //write result to register
                      writeEn=1;
                      state=state+1;
                    end
                    3'b100: begin       //update flags
                      writeEn=0;
                      SREG=aluSREG;
                      state=state+1;
                    end
                    3'b101: begin        //latency
                      state=0;
                      hold=0;
                    end
                    default: state=0;
                endcase
                end
            2'b01:  begin //Load - immediate, direct, indirect
                case(opcode[3:0])
                    4'b0001: begin //immediate
                        immediateValue = instruction[10:3]; //can load from 0-255
                        regNum = instruction[2:0];
                        case(state)
                            3'b000: begin
                                regCIn=immediateValue;
                                writeEn=0;
                                readEn=0;
                                hold=1;
                                state=state+1;
                            end
                            3'b001: begin
                                regCNum=regNum;

                            end
                        endcase
                    end
                endcase
            end
            2'b10:  begin //Branch Instructions
            end
            2'b11:  begin //outlier instructions - MOV, NOP
            end
        endcase
        pcCurrent <= pcNext;
    end
endmodule
/*
4'b0000: begin      //ALU direct data processing
  //hold=1;
  rd=instruction[11:9];
  ra=instruction[8:6];
  rb=instruction[5:3];
  alu_control=instruction[2:0];
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b000001;

  case(state)
  3'b000: begin      //read ra, rb from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin      //latency
    state=state+1;
  end
  3'b010: begin      //set up ALU parameters
    RA=0;
    a=ra_data;
    b=rb_data;
    state=state+1;
  end
  3'b011: begin      //allow ALU to process
    rd_data=result;
    state=state+1;
    WR=1;
  end
  3'b100: begin        //write to register
    WR=1;
    state=state+1;
  end
  3'b101: begin
    WR=0;
    rd=3'd0;
    state=state+1;
  end
  3'b110: begin        //write to register
    //WR=1;
    rd_data={7'd0,carry};
    state=state+1;
    hold=0;
  end
  3'b111: begin        //latency
    WR=0;
    state=0;
    hold=1;
  end
  endcase
end

4'b0100:
  begin      //addi rd<=ra+imm
  //hold=1;
  ra=instruction[8:6];
  rd=instruction[5:3];
  imm={instruction[11:9],instruction[2:0]};
  alu_control=0;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b000001;

  case(state)
  3'b000: begin        //read ra, imem from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin        //buffer
    state=state+1;
  end
  3'b010: begin        //setup data
    RA=0;
    a=ra_data;
    b={2'b00,imm};
    state=state+1;
  end
  3'b011: begin        //process with ALU
    state=state+1;
  end
  3'b100: begin        //begin write to register
    rd_data=result;
    $display("result",result);
    state=state+1;
  end
  3'b101: begin        //write to register
    WR=1;
    state=state+1;
  end
  3'b110: begin        //write to register
    state=state+1;
    hold=0;
  end
  3'b111:
  begin        //one cycle for latency
    WR=0;
    state=0;
    hold=1;
  end
  endcase
end

4'b0101:
  begin      //subi rd<=ra+imm
  //hold=1;
  ra=instruction[8:6];
  rd=instruction[5:3];
  imm={instruction[11:9],instruction[2:0]};
  alu_control=3'b001;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b000001;

  case(state)
  3'b000: begin        //read ra, imem from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin        //buffer
    state=state+1;
  end
  3'b010: begin        //setup data
    RA=0;
    a=ra_data;
    b={2'b00,imm};
    state=state+1;
  end
  3'b011: begin        //process with ALU
    state=state+1;
  end
  3'b100: begin        //begin write to register
    rd_data=result;
    $display("result",result);
    state=state+1;
  end
  3'b101: begin        //write to register
    WR=1;
    state=state+1;
  end
  3'b110: begin        //write to register
    state=state+1;
    hold=0;
  end
  3'b111:
  begin        //one cycle for latency
    WR=0;
    state=0;
    hold=1;
  end
  endcase
end

4'b1011: begin      //load value.
//  hold=1;
  ra=instruction[8:6];
  rd=instruction[5:3];
  imm={instruction[11:9],instruction[2:0]};
  alu_control=0;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b000111;

  case(state)
  3'b000: begin        //read ra, imem from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin        //read from memory
    RA=0;
    mem_access_addr=ra_data+{2'b00,imm};
    state=state+1;
  end
  3'b010: begin        //read from memory
    mem_read=1;
    state=state+1;
  end
  3'b011: begin        //write to register rd
    rd_data=mem_read_data;
    mem_read=0;
    state=state+1;
  end
  3'b100: begin        //write to register rd
    WR=1;
    state=state+1;
    hold=0;
  end
  3'b101:
  begin        //one cycle for latency
    WR=0;
    state=0;
    hold=1;
  end
  endcase
end

4'b1111: begin       //store value
  //hold=1;
  ra=instruction[8:6];
  rb=instruction[5:3];
  imm={instruction[11:9],instruction[2:0]};
  alu_control=0;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b001100;

  case(state)
  3'b000: begin        //read ra,rb imem from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin        //write to data mem
    mem_access_addr=ra_data+{2'b00,imm};
    state=state+1;
  end
  3'b010: begin        //latency
    RA=0;
    mem_write_data=rb_data;
    mem_write_en=1;
    state=state+1;
  end
  3'b011: begin        //latency
    state=state+1;
    hold=0;
  end
  3'b100: begin        //latency
    mem_write_en=0;
    state=0;
    hold=1;
  end
  endcase

end

4'b1000: begin      //branch if equal
  //hold=1;
  ra=instruction[8:6];
  rb=instruction[5:3];
  imm={instruction[11:9],instruction[2:0]};
  alu_control=3'b001;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b010000;

  case(state)
  3'b000: begin      //read ra, rb from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin      //allow ALU to process
    state=state+1;

  end
  3'b010: begin      //allow ALU to process
    RA=0;
    a=ra_data;
    b=rb_data;
    state=state+1;
  end
  3'b011: begin        //update pc
    if (zero==1'b1) begin
      branch_immem=imm;
      end
    else
      branch=0;
    state=state+1;
    hold=0;
  end
  3'b100: begin     //release all holds
    state=0;
    hold=1;
  end
endcase

end

4'b1001: begin      //branch if not equal
  //hold=1;
  ra=instruction[8:6];
  rb=instruction[5:3];
  imm={instruction[11:9],instruction[2:0]};
  alu_control=3'b001;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b010000;

  case(state)
  3'b000: begin      //read ra, rb from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin      //allow ALU to process
    state=state+1;

  end
  3'b010: begin      //allow ALU to process
    RA=0;
    a=ra_data;
    b=rb_data;
    state=state+1;
  end
  3'b011: begin        //update pc
    if (zero==1'b0) begin
      branch_immem=imm;
      end
    else
      branch=0;
    state=state+1;
    hold=0;
  end
  3'b100: begin     //release all holds
    state=0;
    hold=1;
  end
endcase

end

4'b0010: begin        //jump
  case(state)
  3'b000: begin
  hold=0;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b100000;
  jump_line=instruction[6:0];
  state=state+1;
  end
  3'b001: begin
  hold=1;
  jump=0;
  state=0;
  end
  endcase
end

4'b0111: begin
  $display("End Of Program");
  hold=1;
end


4'b0011: begin      //mov Ra Rb
  //hold=1;
  ra=instruction[11:9];
  rd=instruction[8:6];
  alu_control=0;
  {jump,branch,mem_write,alu_src,mem_to_reg,reg_write}=6'b000001;

  case(state)
  3'b000: begin      //read ra from Instructions
    hold=1;
    RA=1;
    state=state+1;
  end
  3'b001: begin      //latency
    state=state+1;
  end
  3'b010: begin      //set up rd
    RA=0;
    rd_data=ra_data;
    state=state+1;
  end
  3'b011: begin      //allow latency to process
    state=state+1;
    WR=1;
  end
  3'b100: begin        //write to register ra (0)
    WR=0;
    rd=ra;
    rd_data=0;
    state=state+1;
  end
  3'b101: begin
    WR=1;
    state=state+1;
  end
  3'b110: begin        //write to register
    state=state+1;
    hold=0;
  end
  3'b111: begin        //latency
    WR=0;
    state=0;
    hold=1;
  end
  endcase
end

endcase

pc_current=pc_next;
end
*/
