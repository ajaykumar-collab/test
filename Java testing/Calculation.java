public class Calculation {
    public static int sum(int n) {
        int sum = 0;
        for (int i = 1; i <= n; i++) {
            sum += i;
        }
        return sum;
    }

    public static int product(int n) {
        int product = 1;
        for (int i = 1; i <= n; i++) {
            product *= i;
        }
        return product;
    }

    public static double division(int num1, int num2) {
        if (num2 == 0) {
            throw new ArithmeticException("Division by zero is not allowed.");
        }
        return (double) num1 / num2;
    }

    public static int subtract(int a, int b) {
        return a - b;
    }

    public static double calculateTotal(int amount,int tax){
        return Math.round(amount*((1+tax)/100.0));
    }
}
