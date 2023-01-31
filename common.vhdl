library ieee;
use ieee.std_logic_1164.all;

package common is

  type controls_t is record

    /* enable write to rd */
    rd_write:   std_ulogic;

    /*
      alu src a
      '0' rs1
      '1' pc
    */
    alu_srca:   std_ulogic;

    /*
      alu src b
      '0' rs2
      '1' imm
    */
    alu_srcb:   std_ulogic;

    /*
    */
    branch:     std_ulogic;

    /* enable write to memory */
    memwrite:   std_ulogic;

    /*
      rc src: "00" alu, "01" memory, "10" pc + 4
    */
    rd_src:     std_ulogic_vector(1 downto 0);

    /*
    */
    jump:       std_ulogic;

    /*
    0000   none
    0001   a + b
    0010   a - b
    0011   a and b
    0100   a or b
    0101   a xor b
    0111   a sll b
    0111   a srl b
    1000   a sra b
    1001   a
    1010   b
    1011   a < b
    */
    alu_ctl:    std_ulogic_vector(3 downto 0);

    /*
    001   I-type: addi, lw, jalr
    010   S-type: sw
    011   U-type: lui, auipc
    100   B-type: beq, bne
    101   J-type: jal, j
    */
    imm_ctl:    std_ulogic_vector(2 downto 0);

    /*
    000   1 byte
    001   2 byte
    010   4 byte
    100   1 byte sign ext
    101   2 byte sign ext
    */
    mem_ctl:    std_ulogic_vector(2 downto 0);

  end record controls_t;

end package;

package body common is

end package body common;
