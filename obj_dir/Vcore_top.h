// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VCORE_TOP_H_
#define _VCORE_TOP_H_  // guard

#include "verilated.h"

//==========

class Vcore_top__Syms;
class Vcore_top_VerilatedVcd;


//----------

VL_MODULE(Vcore_top) {
  public:
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    VL_OUT8(dmem_wen,0,0);
    VL_IN(imem_rdata,31,0);
    VL_OUT64(imem_addr,63,0);
    VL_OUT64(dmem_addr,63,0);
    VL_OUT64(dmem_wdata,63,0);
    VL_IN64(dmem_rdata,63,0);
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*3:0*/ core_top__DOT__dec_alu_op;
    CData/*0:0*/ core_top__DOT__dec_reg_write;
    CData/*0:0*/ core_top__DOT__dec_alu_src;
    CData/*4:0*/ core_top__DOT__ex_rd_addr;
    CData/*3:0*/ core_top__DOT__ex_alu_op;
    CData/*0:0*/ core_top__DOT__ex_reg_write;
    CData/*0:0*/ core_top__DOT__ex_alu_src;
    CData/*4:0*/ core_top__DOT__ex_rs1_addr;
    CData/*4:0*/ core_top__DOT__ex_rs2_addr;
    CData/*4:0*/ core_top__DOT__mem_rd_addr;
    CData/*0:0*/ core_top__DOT__mem_reg_write;
    CData/*4:0*/ core_top__DOT__wb_rd_addr;
    CData/*0:0*/ core_top__DOT__wb_reg_write;
    CData/*0:0*/ core_top__DOT__wb_mem_to_reg;
    IData/*31:0*/ core_top__DOT__id_instr;
    IData/*31:0*/ core_top__DOT__u_rom__DOT__unnamedblk1__DOT__i;
    IData/*31:0*/ core_top__DOT__u_regfile__DOT__unnamedblk1__DOT__i;
    QData/*63:0*/ core_top__DOT__id_pc;
    QData/*63:0*/ core_top__DOT__ex_rs1_data;
    QData/*63:0*/ core_top__DOT__ex_rs2_data;
    QData/*63:0*/ core_top__DOT__ex_imm;
    QData/*63:0*/ core_top__DOT__alu_result;
    QData/*63:0*/ core_top__DOT__mem_alu_result;
    QData/*63:0*/ core_top__DOT__mem_rs2_data;
    QData/*63:0*/ core_top__DOT__alu_operand_a;
    QData/*63:0*/ core_top__DOT__alu_operand_b;
    QData/*63:0*/ core_top__DOT__wb_alu_result;
    QData/*63:0*/ core_top__DOT__wb_mem_data;
    QData/*63:0*/ core_top__DOT__wb_final_data;
    QData/*63:0*/ core_top__DOT__u_fetch__DOT__pc_next;
    QData/*63:0*/ core_top__DOT__u_fetch__DOT__pc_curr;
    IData/*31:0*/ core_top__DOT__u_rom__DOT__mem[1024];
    QData/*63:0*/ core_top__DOT__u_regfile__DOT__regs[32];
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __Vclklast__TOP__clk;
    CData/*0:0*/ __Vclklast__TOP__rst_n;
    CData/*0:0*/ __Vm_traceActivity[2];
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vcore_top__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vcore_top);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    Vcore_top(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vcore_top();
    /// Trace signals in the model; called by application code
    void trace(VerilatedVcdC* tfp, int levels, int options = 0);
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval() { eval_step(); }
    /// Evaluate when calling multiple units/models per time step.
    void eval_step();
    /// Evaluate at end of a timestep for tracing, when using eval_step().
    /// Application must call after all eval() and before time changes.
    void eval_end_step() {}
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vcore_top__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vcore_top__Syms* symsp, bool first);
  private:
    static QData _change_request(Vcore_top__Syms* __restrict vlSymsp);
    static QData _change_request_1(Vcore_top__Syms* __restrict vlSymsp);
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vcore_top__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vcore_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vcore_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__1(Vcore_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _sequent__TOP__2(Vcore_top__Syms* __restrict vlSymsp);
    static void _settle__TOP__3(Vcore_top__Syms* __restrict vlSymsp) VL_ATTR_COLD;
  private:
    static void traceChgSub0(void* userp, VerilatedVcd* tracep);
    static void traceChgTop0(void* userp, VerilatedVcd* tracep);
    static void traceCleanup(void* userp, VerilatedVcd* /*unused*/);
    static void traceFullSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceFullTop0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitSub0(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInitTop(void* userp, VerilatedVcd* tracep) VL_ATTR_COLD;
    void traceRegister(VerilatedVcd* tracep) VL_ATTR_COLD;
    static void traceInit(void* userp, VerilatedVcd* tracep, uint32_t code) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
