// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcore_top.h for the primary calling header

#include "Vcore_top.h"
#include "Vcore_top__Syms.h"

//==========

VL_CTOR_IMP(Vcore_top) {
    Vcore_top__Syms* __restrict vlSymsp = __VlSymsp = new Vcore_top__Syms(this, name());
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vcore_top::__Vconfigure(Vcore_top__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-12);
    Verilated::timeprecision(-12);
}

Vcore_top::~Vcore_top() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vcore_top::_initial__TOP__1(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_initial__TOP__1\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->dmem_addr = 0ULL;
    vlTOPp->dmem_wdata = 0ULL;
    vlTOPp->dmem_wen = 0U;
    vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i = 0U;
    while (VL_GTS_III(1,32,32, 0x400U, vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i)) {
        vlTOPp->core_top__DOT__u_rom__DOT__mem[(0x3ffU 
                                                & vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i)] = 0x13U;
        vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i 
            = ((IData)(1U) + vlTOPp->core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i);
    }
    vlTOPp->core_top__DOT__u_rom__DOT__mem[0U] = 0x500093U;
    vlTOPp->core_top__DOT__u_rom__DOT__mem[1U] = 0xa00113U;
    vlTOPp->core_top__DOT__u_rom__DOT__mem[2U] = 0x2081b3U;
}

void Vcore_top::_settle__TOP__3(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_settle__TOP__3\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->imem_addr = vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr;
    vlTOPp->core_top__DOT__u_fetch__DOT__pc_next = 
        (4ULL + vlTOPp->core_top__DOT__u_fetch__DOT__pc_curr);
}

void Vcore_top::_eval_initial(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_eval_initial\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vm_traceActivity[1U] = 1U;
    vlTOPp->__Vm_traceActivity[0U] = 1U;
    vlTOPp->__Vclklast__TOP__clk = vlTOPp->clk;
    vlTOPp->__Vclklast__TOP__rst_n = vlTOPp->rst_n;
}

void Vcore_top::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::final\n"); );
    // Variables
    Vcore_top__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vcore_top::_eval_settle(Vcore_top__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_eval_settle\n"); );
    Vcore_top* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__3(vlSymsp);
}

void Vcore_top::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcore_top::_ctor_var_reset\n"); );
    // Body
    clk = VL_RAND_RESET_I(1);
    rst_n = VL_RAND_RESET_I(1);
    imem_addr = VL_RAND_RESET_Q(64);
    imem_rdata = VL_RAND_RESET_I(32);
    dmem_addr = VL_RAND_RESET_Q(64);
    dmem_wdata = VL_RAND_RESET_Q(64);
    dmem_wen = VL_RAND_RESET_I(1);
    dmem_rdata = VL_RAND_RESET_Q(64);
    core_top__DOT__id_pc = VL_RAND_RESET_Q(64);
    core_top__DOT__id_instr = VL_RAND_RESET_I(32);
    core_top__DOT__u_fetch__DOT__pc_next = VL_RAND_RESET_Q(64);
    core_top__DOT__u_fetch__DOT__pc_curr = VL_RAND_RESET_Q(64);
    { int __Vi0=0; for (; __Vi0<1024; ++__Vi0) {
            core_top__DOT__u_rom__DOT__mem[__Vi0] = VL_RAND_RESET_I(32);
    }}
    core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i = 0;
    { int __Vi0=0; for (; __Vi0<2; ++__Vi0) {
            __Vm_traceActivity[__Vi0] = VL_RAND_RESET_I(1);
    }}
}
