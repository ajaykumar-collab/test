public class Test {
    public static void main(String[] args) {
        // Calculate the sum of numbers from 1 to 100
        int sumRange = 100;
        System.out.println("Sum of 1 to 100 is " + Calculation.sum(sumRange));

        // Calculate the product of numbers from 1 to 10
        int productRange = 10;
        System.out.println("Product of 1 to 10 is " + Calculation.product(productRange));

        System.out.println("Division of 10 by 2 is " + Calculation.division(10, 2));
        System.out.println("Subtraction of two numbers 10 and 5 is " + Calculation.subtract(10, 5));

        System.out.println("Amount "+Calculation.calculateTotal(100,5));
    }
}
