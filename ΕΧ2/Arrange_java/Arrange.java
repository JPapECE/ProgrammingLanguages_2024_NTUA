package ΕΧ2.Arrange_java;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Arrange {
    static class NodeResult {
        TreeNode node;
        int index;

        public NodeResult(TreeNode node, int index) {
            this.node = node;
            this.index = index;
        }
    }

    static TreeNode swapN(TreeNode n) {
        TreeNode temp = n.left;
        n.left = n.right;
        n.right = temp;
        return n;
    }

    static boolean isLeaf(TreeNode n) {
        return n.left == null && n.right == null;
    }

    static int minleaf(TreeNode n) {
        if (isLeaf(n)) return n.info;
        if (n.left == null) return Math.min(n.info, minleaf(n.right));
        if (n.right == null) return Math.min(n.info, minleaf(n.left));
        return Math.min(minleaf(n.left), minleaf(n.right));
    }

    static void inorder(TreeNode n) {
        if (n == null) return;
        inorder(n.left);
        System.out.print(n.info + " ");
        inorder(n.right);
    }

    static NodeResult prein(int[] inf, int index) {
        if (inf[index] == 0) return new NodeResult(null, index + 1);
        TreeNode p = new TreeNode(inf[index]);
        NodeResult leftResult = prein(inf, index + 1);
        p.left = leftResult.node;
        NodeResult rightResult = prein(inf, leftResult.index);
        p.right = rightResult.node;
        return new NodeResult(p, rightResult.index);
    }

    static TreeNode fix(TreeNode n) {
        if (n == null) return null;
        if (isLeaf(n)) return n;
        if (n.left == null && n.right != null) {
            if (n.info > minleaf(n.right)) {
                n = swapN(n);
                n.left = fix(n.left);
                n.right = null;
            } else {
                n.right = fix(n.right);
                n.left = null;
            }
            return n;
        }
        if (n.right == null && n.left != null) {
            if (n.info < minleaf(n.left)) {
                n = swapN(n);
                n.right = fix(n.right);
                n.left = null;
            } else {
                n.left = fix(n.left);
                n.right = null;
            }
            return n;
        }
        if (minleaf(n.right) < minleaf(n.left)) n = swapN(n);
        n.left = fix(n.left);
        n.right = fix(n.right);
        return n;
    }

    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("Usage: java Main <input_file>");
            return;
        }

        try {
            Scanner scanner = new Scanner(new File(args[0]));
            int n = scanner.nextInt();
            int[] arr = new int[2 * n + 1];
            int i = 0;

            while (i < 2 * n + 1) {
                arr[i++] = scanner.nextInt();
            }

            NodeResult rootResult = prein(arr, 0);
            TreeNode root = rootResult.node;
            root = fix(root);
            inorder(root);
            System.out.println();
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + args[0]);
        }
    }
}