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
        tracep->declBit(c+16,"clk", false,-1);
        tracep->declBit(c+17,"rst_n", false,-1);
        tracep->declQuad(c+18,"imem_addr", false,-1, 63,0);
        tracep->declBus(c+20,"imem_rdata", false,-1, 31,0);
        tracep->declQuad(c+21,"dmem_addr", false,-1, 63,0);
        tracep->declQuad(c+23,"dmem_wdata", false,-1, 63,0);
        tracep->declBit(c+25,"dmem_wen", false,-1);
        tracep->declQuad(c+26,"dmem_rdata", false,-1, 63,0);
        tracep->declBit(c+16,"core_top clk", false,-1);
        tracep->declBit(c+17,"core_top rst_n", false,-1);
        tracep->declQuad(c+18,"core_top imem_addr", false,-1, 63,0);
        tracep->declBus(c+20,"core_top imem_rdata", false,-1, 31,0);
        tracep->declQuad(c+21,"core_top dmem_addr", false,-1, 63,0);
        tracep->declQuad(c+23,"core_top dmem_wdata", false,-1, 63,0);
        tracep->declBit(c+25,"core_top dmem_wen", false,-1);
        tracep->declQuad(c+26,"core_top dmem_rdata", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top current_pc", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top fetch_addr", false,-1, 63,0);
        tracep->declBus(c+4,"core_top raw_instr", false,-1, 31,0);
        tracep->declBus(c+5,"core_top dec_opcode", false,-1, 6,0);
        tracep->declBus(c+6,"core_top dec_rs1", false,-1, 4,0);
        tracep->declBus(c+7,"core_top dec_rs2", false,-1, 4,0);
        tracep->declBus(c+8,"core_top dec_rd", false,-1, 4,0);
        tracep->declQuad(c+9,"core_top id_pc", false,-1, 63,0);
        tracep->declBus(c+11,"core_top id_instr", false,-1, 31,0);
        tracep->declBus(c+20,"core_top unused_imem", false,-1, 31,0);
        tracep->declQuad(c+26,"core_top unused_dmem", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top unused_pc", false,-1, 63,0);
        tracep->declBus(c+5,"core_top unused_opcode", false,-1, 6,0);
        tracep->declBus(c+6,"core_top unused_rs1", false,-1, 4,0);
        tracep->declBus(c+7,"core_top unused_rs2", false,-1, 4,0);
        tracep->declBus(c+8,"core_top unused_rd", false,-1, 4,0);
        tracep->declQuad(c+9,"core_top unused_id_pc", false,-1, 63,0);
        tracep->declBit(c+16,"core_top u_fetch clk", false,-1);
        tracep->declBit(c+17,"core_top u_fetch rst_n", false,-1);
        tracep->declQuad(c+28,"core_top u_fetch branch_target_i", false,-1, 63,0);
        tracep->declBit(c+30,"core_top u_fetch branch_taken_i", false,-1);
        tracep->declQuad(c+2,"core_top u_fetch imem_addr_o", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top u_fetch pc_out_o", false,-1, 63,0);
        tracep->declQuad(c+12,"core_top u_fetch pc_next", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top u_fetch pc_curr", false,-1, 63,0);
        tracep->declQuad(c+2,"core_top u_rom addr_i", false,-1, 63,0);
        tracep->declBus(c+4,"core_top u_rom data_o", false,-1, 31,0);
        tracep->declQuad(c+2,"core_top u_rom unused_addr", false,-1, 63,0);
        tracep->declBus(c+1,"core_top u_rom unnamedblk1 i", false,-1, 31,0);
        tracep->declBit(c+16,"core_top u_if_id clk", false,-1);
        tracep->declBit(c+17,"core_top u_if_id rst_n", false,-1);
        tracep->declBit(c+30,"core_top u_if_id stall_i", false,-1);
        tracep->declBit(c+30,"core_top u_if_id flush_i", false,-1);
        tracep->declQuad(c+2,"core_top u_if_id pc_i", false,-1, 63,0);
        tracep->declBus(c+4,"core_top u_if_id instr_i", false,-1, 31,0);
        tracep->declQuad(c+9,"core_top u_if_id pc_o", false,-1, 63,0);
        tracep->declBus(c+11,"core_top u_if_id instr_o", false,-1, 31,0);
        tracep->declBus(c+11,"core_top u_decode instr_i", false,-1, 31,0);
        tracep->declBus(c+5,"core_top u_decode opcode_o", false,-1, 6,0);
        tracep->declBus(c+6,"core_top u_decode rs1_addr_o", false,-1, 4,0);
        tracep->declBus(c+7,"core_top u_decode rs2_addr_o", false,-1, 4,0);
        tracep->declBus(c+8,"core_top u_decode rd_addr_o", false,-1, 4,0);
        tracep->declBus(c+14,"core_top u_decode funct3_o", false,-1, 2,0);
        tracep->declBus(c+15,"core_top u_decode funct7_o", false,-1, 6,0);
        tracep->declBus(c+31,"riscv_pkg XLEN", false,-1, 31,0);
        tracep->declBus(c+32,"riscv_pkg ILEN", false,-1, 31,0);
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
        tracep->fullCData(oldp+5,((0x7fU & vlTOPp->core_top__DOT__id_instr)),7);
        tracep->fullCData(oldp+6,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                            >> 0xfU))),5);
        tracep->fullCData(oldp+7,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                            >> 0x14U))),5);
        tracep->fullCData(oldp+8,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                            >> 7U))),5);
        tracep->fullQData(oldp+9,(vlTOPp->core_top__DOT__id_pc),64);
        tracep->fullIData(oldp+11,(vlTOPp->core_top__DOT__id_instr),32);
        tracep->fullQData(oldp+12,((4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr)),64);
        tracep->fullCData(oldp+14,((7U & (vlTOPp->core_top__DOT__id_instr 
                                          >> 0xcU))),3);
        tracep->fullCData(oldp+15,((0x7fU & (vlTOPp->core_top__DOT__id_instr 
                                             >> 0x19U))),7);
        tracep->fullBit(oldp+16,(vlTOPp->clk));
        tracep->fullBit(oldp+17,(vlTOPp->rst_n));
        tracep->fullQData(oldp+18,(vlTOPp->imem_addr),64);
        tracep->fullIData(oldp+20,(vlTOPp->imem_rdata),32);
        tracep->fullQData(oldp+21,(vlTOPp->dmem_addr),64);
        tracep->fullQData(oldp+23,(vlTOPp->dmem_wdata),64);
        tracep->fullBit(oldp+25,(vlTOPp->dmem_wen));
        tracep->fullQData(oldp+26,(vlTOPp->dmem_rdata),64);
        tracep->fullQData(oldp+28,(0ULL),64);
        tracep->fullBit(oldp+30,(0U));
        tracep->fullIData(oldp+31,(0x40U),32);
        tracep->fullIData(oldp+32,(0x20U),32);
    }
}
