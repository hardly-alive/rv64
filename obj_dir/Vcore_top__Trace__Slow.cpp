// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcore_top__Syms.h"


//======================

void Vcore_top::trace(VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addInitCb(&traceInit, __VlSymsp);
    traceRegister(tfp->spTrace());
}

void Vcore_top::traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    if (!Verilated::calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
                        "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->module(vlSymsp->name());
    tracep->scopeEscape(' ');
    Vcore_top::traceInitTop(vlSymsp, tracep);
    tracep->scopeEscape('.');
}

//======================


void Vcore_top::traceInitTop(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceInitSub0(userp, tracep);
    }
}

void Vcore_top::traceInitSub0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    const int c = vlSymsp->__Vm_baseCode;
    if (false && tracep && c) {}  // Prevent unused
    // Body
    {
        tracep->declBit(c+104,"clk", false,-1);
        tracep->declBit(c+105,"rst_n", false,-1);
        tracep->declQuad(c+106,"imem_addr", false,-1, 63,0);
        tracep->declBus(c+108,"imem_rdata", false,-1, 31,0);
        tracep->declQuad(c+109,"dmem_addr", false,-1, 63,0);
        tracep->declQuad(c+111,"dmem_wdata", false,-1, 63,0);
        tracep->declBit(c+113,"dmem_wen", false,-1);
        tracep->declQuad(c+114,"dmem_rdata", false,-1, 63,0);
        tracep->declBit(c+104,"core_top clk", false,-1);
        tracep->declBit(c+105,"core_top rst_n", false,-1);
        tracep->declQuad(c+106,"core_top imem_addr", false,-1, 63,0);
        tracep->declBus(c+108,"core_top imem_rdata", false,-1, 31,0);
        tracep->declQuad(c+109,"core_top dmem_addr", false,-1, 63,0);
        tracep->declQuad(c+111,"core_top dmem_wdata", false,-1, 63,0);
        tracep->declBit(c+113,"core_top dmem_wen", false,-1);
        tracep->declQuad(c+114,"core_top dmem_rdata", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top current_pc", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top fetch_addr", false,-1, 63,0);
        tracep->declBus(c+4,"core_top raw_instr", false,-1, 31,0);
        tracep->declQuad(c+5,"core_top id_pc", false,-1, 63,0);
        tracep->declBus(c+7,"core_top id_instr", false,-1, 31,0);
        tracep->declBus(c+8,"core_top dec_rs1", false,-1, 4,0);
        tracep->declBus(c+9,"core_top dec_rs2", false,-1, 4,0);
        tracep->declBus(c+10,"core_top dec_rd", false,-1, 4,0);
        tracep->declQuad(c+11,"core_top dec_imm", false,-1, 63,0);
        tracep->declBus(c+13,"core_top dec_alu_op", false,-1, 3,0);
        tracep->declBit(c+14,"core_top dec_reg_write", false,-1);
        tracep->declBit(c+15,"core_top dec_alu_src", false,-1);
        tracep->declQuad(c+16,"core_top reg_rs1_data", false,-1, 63,0);
        tracep->declQuad(c+18,"core_top reg_rs2_data", false,-1, 63,0);
        tracep->declQuad(c+20,"core_top ex_rs1_data", false,-1, 63,0);
        tracep->declQuad(c+22,"core_top ex_rs2_data", false,-1, 63,0);
        tracep->declQuad(c+24,"core_top ex_imm", false,-1, 63,0);
        tracep->declBus(c+26,"core_top ex_rd_addr", false,-1, 4,0);
        tracep->declBus(c+27,"core_top ex_alu_op", false,-1, 3,0);
        tracep->declBit(c+28,"core_top ex_reg_write", false,-1);
        tracep->declBit(c+29,"core_top ex_alu_src", false,-1);
        tracep->declQuad(c+30,"core_top alu_operand_b", false,-1, 63,0);
        tracep->declQuad(c+32,"core_top alu_result", false,-1, 63,0);
        tracep->declBus(c+108,"core_top unused_imem", false,-1, 31,0);
        tracep->declQuad(c+114,"core_top unused_dmem", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top unused_pc", false,-1, 63,0);
        tracep->declQuad(c+5,"core_top unused_id_pc", false,-1, 63,0);
        tracep->declBit(c+104,"core_top u_fetch clk", false,-1);
        tracep->declBit(c+105,"core_top u_fetch rst_n", false,-1);
        tracep->declQuad(c+116,"core_top u_fetch branch_target_i", false,-1, 63,0);
        tracep->declBit(c+118,"core_top u_fetch branch_taken_i", false,-1);
        tracep->declQuad(c+2,"core_top u_fetch imem_addr_o", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top u_fetch pc_out_o", false,-1, 63,0);
        tracep->declQuad(c+34,"core_top u_fetch pc_next", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top u_fetch pc_curr", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top u_rom addr_i", false,-1, 63,0);
        tracep->declBus(c+4,"core_top u_rom data_o", false,-1, 31,0);
        tracep->declQuad(c+2,"core_top u_rom unused_addr", false,-1, 63,0);
        tracep->declBus(c+1,"core_top u_rom unnamedblk1 i", false,-1, 31,0);
        tracep->declBit(c+104,"core_top u_if_id clk", false,-1);
        tracep->declBit(c+105,"core_top u_if_id rst_n", false,-1);
        tracep->declBit(c+118,"core_top u_if_id stall_i", false,-1);
        tracep->declBit(c+118,"core_top u_if_id flush_i", false,-1);
        tracep->declQuad(c+2,"core_top u_if_id pc_i", false,-1, 63,0);
        tracep->declBus(c+4,"core_top u_if_id instr_i", false,-1, 31,0);
        tracep->declQuad(c+5,"core_top u_if_id pc_o", false,-1, 63,0);
        tracep->declBus(c+7,"core_top u_if_id instr_o", false,-1, 31,0);
        tracep->declBus(c+7,"core_top u_decode instr_i", false,-1, 31,0);
        tracep->declBus(c+8,"core_top u_decode rs1_addr_o", false,-1, 4,0);
        tracep->declBus(c+9,"core_top u_decode rs2_addr_o", false,-1, 4,0);
        tracep->declBus(c+10,"core_top u_decode rd_addr_o", false,-1, 4,0);
        tracep->declBus(c+13,"core_top u_decode alu_op_o", false,-1, 3,0);
        tracep->declBit(c+14,"core_top u_decode reg_write_o", false,-1);
        tracep->declBit(c+15,"core_top u_decode alu_src_o", false,-1);
        tracep->declQuad(c+11,"core_top u_decode imm_o", false,-1, 63,0);
        tracep->declBus(c+36,"core_top u_decode opcode", false,-1, 6,0);
        tracep->declBus(c+37,"core_top u_decode funct3", false,-1, 2,0);
        tracep->declBus(c+38,"core_top u_decode funct7", false,-1, 6,0);
        tracep->declBus(c+38,"core_top u_decode unused_funct7", false,-1, 6,0);
        tracep->declBit(c+104,"core_top u_regfile clk", false,-1);
        tracep->declBit(c+105,"core_top u_regfile rst_n", false,-1);
        tracep->declBus(c+8,"core_top u_regfile rs1_addr_i", false,-1, 4,0);
        tracep->declQuad(c+16,"core_top u_regfile rs1_data_o", false,-1, 63,0);
        tracep->declBus(c+9,"core_top u_regfile rs2_addr_i", false,-1, 4,0);
        tracep->declQuad(c+18,"core_top u_regfile rs2_data_o", false,-1, 63,0);
        tracep->declBus(c+26,"core_top u_regfile rd_addr_i", false,-1, 4,0);
        tracep->declQuad(c+32,"core_top u_regfile rd_data_i", false,-1, 63,0);
        tracep->declBit(c+28,"core_top u_regfile rd_wen_i", false,-1);
        {int i; for (i=0; i<32; i++) {
                tracep->declQuad(c+39+i*2,"core_top u_regfile regs", true,(i+0), 63,0);}}
        tracep->declBus(c+103,"core_top u_regfile unnamedblk1 i", false,-1, 31,0);
        tracep->declBit(c+104,"core_top u_id_ex clk", false,-1);
        tracep->declBit(c+105,"core_top u_id_ex rst_n", false,-1);
        tracep->declQuad(c+16,"core_top u_id_ex rs1_data_i", false,-1, 63,0);
        tracep->declQuad(c+18,"core_top u_id_ex rs2_data_i", false,-1, 63,0);
        tracep->declQuad(c+11,"core_top u_id_ex imm_i", false,-1, 63,0);
        tracep->declBus(c+10,"core_top u_id_ex rd_addr_i", false,-1, 4,0);
        tracep->declBus(c+13,"core_top u_id_ex alu_op_i", false,-1, 3,0);
        tracep->declBit(c+14,"core_top u_id_ex reg_write_i", false,-1);
        tracep->declBit(c+15,"core_top u_id_ex alu_src_i", false,-1);
        tracep->declQuad(c+20,"core_top u_id_ex rs1_data_o", false,-1, 63,0);
        tracep->declQuad(c+22,"core_top u_id_ex rs2_data_o", false,-1, 63,0);
        tracep->declQuad(c+24,"core_top u_id_ex imm_o", false,-1, 63,0);
        tracep->declBus(c+26,"core_top u_id_ex rd_addr_o", false,-1, 4,0);
        tracep->declBus(c+27,"core_top u_id_ex alu_op_o", false,-1, 3,0);
        tracep->declBit(c+28,"core_top u_id_ex reg_write_o", false,-1);
        tracep->declBit(c+29,"core_top u_id_ex alu_src_o", false,-1);
        tracep->declBus(c+27,"core_top u_alu alu_op_i", false,-1, 3,0);
        tracep->declQuad(c+20,"core_top u_alu op_a_i", false,-1, 63,0);
        tracep->declQuad(c+30,"core_top u_alu op_b_i", false,-1, 63,0);
        tracep->declQuad(c+32,"core_top u_alu result_o", false,-1, 63,0);
        tracep->declBus(c+119,"riscv_pkg XLEN", false,-1, 31,0);
        tracep->declBus(c+120,"riscv_pkg ILEN", false,-1, 31,0);
    }
}

void Vcore_top::traceRegister(VerilatedVcd* tracep) {
    // Body
    {
        tracep->addFullCb(&traceFullTop0, __VlSymsp);
        tracep->addChgCb(&traceChgTop0, __VlSymsp);
        tracep->addCleanupCb(&traceCleanup, __VlSymsp);
    }
}

void Vcore_top::traceFullTop0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlTOPp->traceFullSub0(userp, tracep);
    }
}

void Vcore_top::traceFullSub0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        tracep->fullIData(oldp+1,(vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i),32);
        tracep->fullQData(oldp+2,(vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr),64);
        tracep->fullIData(oldp+4,(vlTOPp->core_top__DOT__u_rom__DOT__mem
                                  [(0x3ffU & (IData)(
                                                     (vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr 
                                                      >> 2U)))]),32);
        tracep->fullQData(oldp+5,(vlTOPp->core_top__DOT__id_pc),64);
        tracep->fullIData(oldp+7,(vlTOPp->core_top__DOT__id_instr),32);
        tracep->fullCData(oldp+8,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                            >> 0xfU))),5);
        tracep->fullCData(oldp+9,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                            >> 0x14U))),5);
        tracep->fullCData(oldp+10,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                             >> 7U))),5);
        tracep->fullQData(oldp+11,((((0x13U == (0x7fU 
                                                & vlTOPp->core_top__DOT__id_instr)) 
                                     | (3U == (0x7fU 
                                               & vlTOPp->core_top__DOT__id_instr)))
                                     ? ((0xfffffffffffff000ULL 
                                         & ((- (QData)((IData)(
                                                               (1U 
                                                                & (vlTOPp->core_top__DOT__id_instr 
                                                                   >> 0x1fU))))) 
                                            << 0xcU)) 
                                        | (QData)((IData)(
                                                          (0xfffU 
                                                           & (vlTOPp->core_top__DOT__id_instr 
                                                              >> 0x14U)))))
                                     : 0ULL)),64);
        tracep->fullCData(oldp+13,(vlTOPp->core_top__DOT__dec_alu_op),4);
        tracep->fullBit(oldp+14,(vlTOPp->core_top__DOT__dec_reg_write));
        tracep->fullBit(oldp+15,(vlTOPp->core_top__DOT__dec_alu_src));
        tracep->fullQData(oldp+16,(((0U == (0x1fU & 
                                            (vlTOPp->core_top__DOT__id_instr 
                                             >> 0xfU)))
                                     ? 0ULL : vlTOPp->core_top__DOT__u_regfile__DOT__regs
                                    [(0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 0xfU))])),64);
        tracep->fullQData(oldp+18,(((0U == (0x1fU & 
                                            (vlTOPp->core_top__DOT__id_instr 
                                             >> 0x14U)))
                                     ? 0ULL : vlTOPp->core_top__DOT__u_regfile__DOT__regs
                                    [(0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 0x14U))])),64);
        tracep->fullQData(oldp+20,(vlTOPp->core_top__DOT__ex_rs1_data),64);
        tracep->fullQData(oldp+22,(vlTOPp->core_top__DOT__ex_rs2_data),64);
        tracep->fullQData(oldp+24,(vlTOPp->core_top__DOT__ex_imm),64);
        tracep->fullCData(oldp+26,(vlTOPp->core_top__DOT__ex_rd_addr),5);
        tracep->fullCData(oldp+27,(vlTOPp->core_top__DOT__ex_alu_op),4);
        tracep->fullBit(oldp+28,(vlTOPp->core_top__DOT__ex_reg_write));
        tracep->fullBit(oldp+29,(vlTOPp->core_top__DOT__ex_alu_src));
        tracep->fullQData(oldp+30,(vlTOPp->core_top__DOT__alu_operand_b),64);
        tracep->fullQData(oldp+32,(vlTOPp->core_top__DOT__alu_result),64);
        tracep->fullQData(oldp+34,((4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr)),64);
        tracep->fullCData(oldp+36,((0x7fU & vlTOPp->core_top__DOT__id_instr)),7);
        tracep->fullCData(oldp+37,((7U & (vlTOPp->core_top__DOT__id_instr 
                                          >> 0xcU))),3);
        tracep->fullCData(oldp+38,((0x7fU & (vlTOPp->core_top__DOT__id_instr 
                                             >> 0x19U))),7);
        tracep->fullQData(oldp+39,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[0]),64);
        tracep->fullQData(oldp+41,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[1]),64);
        tracep->fullQData(oldp+43,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[2]),64);
        tracep->fullQData(oldp+45,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[3]),64);
        tracep->fullQData(oldp+47,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[4]),64);
        tracep->fullQData(oldp+49,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[5]),64);
        tracep->fullQData(oldp+51,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[6]),64);
        tracep->fullQData(oldp+53,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[7]),64);
        tracep->fullQData(oldp+55,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[8]),64);
        tracep->fullQData(oldp+57,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[9]),64);
        tracep->fullQData(oldp+59,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[10]),64);
        tracep->fullQData(oldp+61,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[11]),64);
        tracep->fullQData(oldp+63,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[12]),64);
        tracep->fullQData(oldp+65,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[13]),64);
        tracep->fullQData(oldp+67,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[14]),64);
        tracep->fullQData(oldp+69,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[15]),64);
        tracep->fullQData(oldp+71,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[16]),64);
        tracep->fullQData(oldp+73,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[17]),64);
        tracep->fullQData(oldp+75,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[18]),64);
        tracep->fullQData(oldp+77,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[19]),64);
        tracep->fullQData(oldp+79,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[20]),64);
        tracep->fullQData(oldp+81,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[21]),64);
        tracep->fullQData(oldp+83,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[22]),64);
        tracep->fullQData(oldp+85,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[23]),64);
        tracep->fullQData(oldp+87,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[24]),64);
        tracep->fullQData(oldp+89,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[25]),64);
        tracep->fullQData(oldp+91,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[26]),64);
        tracep->fullQData(oldp+93,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[27]),64);
        tracep->fullQData(oldp+95,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[28]),64);
        tracep->fullQData(oldp+97,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[29]),64);
        tracep->fullQData(oldp+99,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[30]),64);
        tracep->fullQData(oldp+101,(vlTOPp->core_top__DOT__u_regfile__DOT__regs[31]),64);
        tracep->fullIData(oldp+103,(vlTOPp->core_top__DOT__u_regfile__DOT__unnamedblk1__DOT__i),32);
        tracep->fullBit(oldp+104,(vlTOPp->clk));
        tracep->fullBit(oldp+105,(vlTOPp->rst_n));
        tracep->fullQData(oldp+106,(vlTOPp->imem_addr),64);
        tracep->fullIData(oldp+108,(vlTOPp->imem_rdata),32);
        tracep->fullQData(oldp+109,(vlTOPp->dmem_addr),64);
        tracep->fullQData(oldp+111,(vlTOPp->dmem_wdata),64);
        tracep->fullBit(oldp+113,(vlTOPp->dmem_wen));
        tracep->fullQData(oldp+114,(vlTOPp->dmem_rdata),64);
        tracep->fullQData(oldp+116,(0ULL),64);
        tracep->fullBit(oldp+118,(0U));
        tracep->fullIData(oldp+119,(0x40U),32);
        tracep->fullIData(oldp+120,(0x20U),32);
    }
}
