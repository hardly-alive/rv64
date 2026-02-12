int main() {
    long long a = 5;
    long long b = 10;
    long long c = a * b;  // Should compile to MUL instruction
    return (int)c;       // Result (50) will be in register a0 (x10)
}