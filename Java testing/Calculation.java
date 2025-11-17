public class Calculation {
    public static int sum(int n) {
        int sum = 0;
        for (int i = 1; i <= n; i++) {
            sum += i;
        }
        System.out.println( "Sum of 1 to " + n + " is " + sum);
        return sum;
    }
    public static int product(int n) {
        int product = 1;
        for (int i = 1; i <= n; i++) {
            product *= i;
        }
        System.out.println( "Product of 1 to " + n + " is " + product);
        return product;
    }
}
