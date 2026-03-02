import os
import subprocess
import sys

# Configuration
TEST_SRC_DIR = "dv/tests/src"
TEST_BIN_DIR = "dv/tests/bin"
PROG_HEX = "sw/program.hex"
SIM_EXE = "./obj_dir/Vcore_top"

# Ensure bin directory exists
os.makedirs(TEST_BIN_DIR, exist_ok=True)

def compile_test(test_name, ext):
    """Compiles a specific C or S test to .bin and then to .hex"""
    src_file = os.path.join(TEST_SRC_DIR, test_name + ext)
    elf_file = os.path.join(TEST_BIN_DIR, test_name + ".elf")
    bin_file = os.path.join(TEST_BIN_DIR, test_name + ".bin")
    
    # 1. Compile (GCC)
    if ext == ".c":
        # C Tests: Require our custom crt0.s startup file
        cmd_gcc = [
            "riscv64-unknown-elf-gcc",
            "-mcmodel=medany",
            "-march=rv64im", "-mabi=lp64", "-nostdlib",
            "-T", "sw/link.ld",
            "-o", elf_file,
            "sw/crt0.s", src_file
        ]
    elif ext == ".S":
        # Official Assembly Tests: Do NOT use crt0.s. Add include paths for macros.
        cmd_gcc = [
            "riscv64-unknown-elf-gcc",
            "-D__ASSEMBLY__=1",
            "-mcmodel=medany",
            "-march=rv64im", "-mabi=lp64", "-nostdlib",
            "-I", "dv/tests/env",                           # Our custom bridge riscv_test.h
            "-I", "dv/riscv-tests-repo/isa/macros/scalar",  # Official test_macros.h
            "-I", "dv/riscv-tests-repo/env/p",              # Official env headers
            "-T", "sw/link.ld",
            "-o", elf_file,
            src_file
        ]
    else:
        return False

    if subprocess.call(cmd_gcc) != 0:
        print(f"❌ [COMPILE ERROR] {test_name}{ext}")
        return False

    # 2. Objcopy (ELF -> BIN)
    cmd_objcopy = ["riscv64-unknown-elf-objcopy", "-O", "binary", elf_file, bin_file]
    if subprocess.call(cmd_objcopy) != 0:
        return False

    # 3. Hex Dump (BIN -> HEX)
    cmd_hex = f"hexdump -v -e '1/1 \"%02x\\n\"' {bin_file} > {PROG_HEX}"
    if os.system(cmd_hex) != 0:
        return False

    return True

def run_simulation():
    """Runs the Verilator simulation and checks the exit code"""
    try:
        # We capture stdout to keep the terminal clean
        result = subprocess.run([SIM_EXE], capture_output=True, text=True)
        
        # Check for our specific "TEST PASSED" string
        if result.returncode == 0 and "TEST PASSED" in result.stdout:
            return True, result.stdout
        else:
            return False, result.stdout
            
    except Exception as e:
        return False, str(e)

def main():
    # 1. Rebuild Hardware
    print("🔨 Building Hardware Simulator...")
    if subprocess.call(["make", "hw"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) != 0:
        print("❌ CRITICAL: Hardware build failed!")
        sys.exit(1)

    # 2. Find all .c and .S files
    test_files = [f for f in os.listdir(TEST_SRC_DIR) if f.endswith(".c") or f.endswith(".S")]
    
    print(f"🔍 Found {len(test_files)} tests. Starting Regression...\n")
    print(f"{'TEST NAME':<30} | {'STATUS':<10}")
    print("-" * 45)

    passed = 0
    failed = 0

    for test_file in test_files:
        test_name, ext = os.path.splitext(test_file)
        
        # Compile
        if not compile_test(test_name, ext):
            print(f"{test_name+ext:<30} | ❌ COMPILE FAIL")
            failed += 1
            continue

        # Run
        success, log = run_simulation()
        
        if success:
            print(f"{test_name+ext:<30} | ✅ PASS")
            passed += 1
        else:
            print(f"{test_name+ext:<30} | ❌ FAIL")
            # print(log) # Uncomment if you want to see the Verilator output on failure
            failed += 1

    print("-" * 45)
    print(f"SUMMARY: {passed} Passed, {failed} Failed")
    
    if failed > 0:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == "__main__":
    main()