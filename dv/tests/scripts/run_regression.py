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

def compile_test(test_name):
    """Compiles a specific C test to .bin and then to .hex"""
    src_file = os.path.join(TEST_SRC_DIR, test_name + ".c")
    elf_file = os.path.join(TEST_BIN_DIR, test_name + ".elf")
    bin_file = os.path.join(TEST_BIN_DIR, test_name + ".bin")
    
    # 1. Compile (GCC)
    cmd_gcc = [
        "riscv64-unknown-elf-gcc",
        "-march=rv64im", "-mabi=lp64", "-nostdlib",
        "-T", "sw/link.ld",
        "-o", elf_file,
        "sw/crt0.s", src_file
    ]
    if subprocess.call(cmd_gcc) != 0:
        print(f"❌ [COMPILE ERROR] {test_name}")
        return False

    # 2. Objcopy (ELF -> BIN)
    cmd_objcopy = ["riscv64-unknown-elf-objcopy", "-O", "binary", elf_file, bin_file]
    if subprocess.call(cmd_objcopy) != 0:
        return False

    # 3. Hex Dump (BIN -> HEX)
    # We use shell=True here to handle the redirect ">" easily
    cmd_hex = f"hexdump -v -e '1/1 \"%02x\\n\"' {bin_file} > {PROG_HEX}"
    if os.system(cmd_hex) != 0:
        return False

    return True

def run_simulation():
    """Runs the Verilator simulation and checks the exit code"""
    try:
        # We capture stdout to keep the terminal clean, unless verbose is needed
        result = subprocess.run([SIM_EXE], capture_output=True, text=True)
        
        # Check for our specific "TEST PASSED" string or exit code 0
        if result.returncode == 0 and "TEST PASSED" in result.stdout:
            return True, result.stdout
        else:
            return False, result.stdout
            
    except Exception as e:
        return False, str(e)

def main():
    # 1. Rebuild Hardware (Just in case)
    print("🔨 Building Hardware Simulator...")
    if subprocess.call(["make", "hw"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) != 0:
        print("❌ CRITICAL: Hardware build failed!")
        sys.exit(1)

    # 2. Find all .c files
    tests = [f[:-2] for f in os.listdir(TEST_SRC_DIR) if f.endswith(".c")]
    
    print(f"🔍 Found {len(tests)} tests. Starting Regression...\n")
    print(f"{'TEST NAME':<30} | {'STATUS':<10}")
    print("-" * 45)

    passed = 0
    failed = 0

    for test in tests:
        # Compile
        if not compile_test(test):
            print(f"{test:<30} | ❌ COMPILE FAIL")
            failed += 1
            continue

        # Run
        success, log = run_simulation()
        
        if success:
            print(f"{test:<30} | ✅ PASS")
            passed += 1
        else:
            print(f"{test:<30} | ❌ FAIL")
            print(log) 
            failed += 1

    print("-" * 45)
    print(f"SUMMARY: {passed} Passed, {failed} Failed")
    
    if failed > 0:
        sys.exit(1)
    else:
        sys.exit(0)

if __name__ == "__main__":
    main()