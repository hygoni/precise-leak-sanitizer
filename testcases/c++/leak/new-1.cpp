void *func1() { 
    new char;
    return new char;
}

void* func2(){
    new char[100];
    return new char[100];
}

int main(void) {
    func2();
    func1();
    return 0;
}
