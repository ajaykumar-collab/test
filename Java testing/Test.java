public class Test {
    public static void main(String[] args) {
        // Calculate the sum of numbers from 1 to 100
        int sum = 0;
        for (int i = 1; i <= 100; i++) {
            sum += i;
        }
        System.out.println("Sum of 1 to 100 is " + sum);

        // Calculate the product of numbers from 1 to 10
        int result = 1;
        for (int i = 1; i <= 10; i++) {
            result *= i;
        }
        System.out.println("Product of 1 to 10 is " + result);
    }
}
