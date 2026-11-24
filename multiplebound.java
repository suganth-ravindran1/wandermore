class Demo<T extends Number & Comparable<T>> {
    private T value;

    public Demo(T value) {
        this.value = value;
    }

    public T getValue() {
        return value;
    }

    public void setValue(T value) {
        this.value = value;
    }

    public void display() {
        System.out.println("Value: " + value);
    }
}
