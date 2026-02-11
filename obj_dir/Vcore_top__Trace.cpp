// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vcore_top__Syms.h"


void Vcore_top::traceChgTop0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Variables
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    {
        vlTOPp->traceChgSub0(userp, tracep);
    }
}

void Vcore_top::traceChgSub0(void* userp, VerilatedVcd* tracep) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    vluint32_t* const oldp = tracep->oldp(vlSymsp->__Vm_baseCode + 1);
    if (false && oldp) {}  // Prevent unused
    // Body
    {
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[0U])) {
            tracep->chgIData(oldp+0,(vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i),32);
        }
        if (VL_UNLIKELY(vlTOPp->__Vm_traceActivity[1U])) {
            tracep->chgQData(oldp+1,(vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr),64);
            tracep->chgIData(oldp+3,(vlTOPp->core_top__DOT__u_rom__DOT__mem
                                     [(0x3ffU & (IData)(
                                                        (vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr 
                                                         >> 2U)))]),32);
            tracep->chgCData(oldp+4,((0x7fU & vlTOPp->core_top__DOT__id_instr)),7);
            tracep->chgCData(oldp+5,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 0xfU))),5);
            tracep->chgCData(oldp+6,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 0x14U))),5);
            tracep->chgCData(oldp+7,((0x1fU & (vlTOPp->core_top__DOT__id_instr 
                                               >> 7U))),5);
            tracep->chgQData(oldp+8,(vlTOPp->core_top__DOT__id_pc),64);
            tracep->chgIData(oldp+10,(vlTOPp->core_top__DOT__id_instr),32);
            tracep->chgQData(oldp+11,((4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr)),64);
            tracep->chgCData(oldp+13,((7U & (vlTOPp->core_top__DOT__id_instr 
                                             >> 0xcU))),3);
            tracep->chgCData(oldp+14,((0x7fU & (vlTOPp->core_top__DOT__id_instr 
                                                >> 0x19U))),7);
        }
        tracep->chgBit(oldp+15,(vlTOPp->clk));
        tracep->chgBit(oldp+16,(vlTOPp->rst_n));
        tracep->chgQData(oldp+17,(vlTOPp->imem_addr),64);
        tracep->chgIData(oldp+19,(vlTOPp->imem_rdata),32);
        tracep->chgQData(oldp+20,(vlTOPp->dmem_addr),64);
        tracep->chgQData(oldp+22,(vlTOPp->dmem_wdata),64);
        tracep->chgBit(oldp+24,(vlTOPp->dmem_wen));
        tracep->chgQData(oldp+25,(vlTOPp->dmem_rdata),64);
    }
}

void Vcore_top::traceCleanup(void* userp, VerilatedVcd* /*unused*/) {
    Vcore_top__Syms* __restrict vlSymsp = static_cast<Vcore_top__Syms*>(userp);
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    {
        vlSymsp->__Vm_activity = false;
        vlTOPp->__Vm_traceActivity[0U] = 0U;
        vlTOPp->__Vm_traceActivity[1U] = 0U;
    }
}
