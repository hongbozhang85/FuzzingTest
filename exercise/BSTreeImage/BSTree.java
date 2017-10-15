package BSTreeImage;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by admin-u6170245 on 28/11/16.
 */
public class BSTree<T> {

    class Node {
        T element;
        Node left, right;

        @Override
        public String toString() {
            if (element == null)
                return "";
            return (left == null ? "" : left.toString()) + element.toString() + (right == null ? "" : right.toString());
        }
    }

    Node root;
    int elements = 0;

    public void add(T element) {
        if (root == null) root = new Node();
        if (nodeAdd(root, element)) elements++;
    }

    private boolean nodeAdd(Node here, T element) {
        if (here.element == null) {
            here.element = element;
            return true;
        } else if (here.element.equals(element)) {
            return false;
        } else if (here.element.hashCode() > element.hashCode()) {
            if (here.left == null) here.left = new Node();
            return nodeAdd(here.left, element);
        } else if (here.element.hashCode() < element.hashCode()) {
            if (here.right == null) here.right = new Node();
            return nodeAdd(here.right, element);
        }
        return true;
    }

    public int size() {
        return elements;
    }

    public boolean contains(T element) {
        return true;
    }

    @Override
    public String toString() {
        if (root == null) return "";
        return root.toString();
    }

    public void toGraph() {
        String result;
        result = "digraph G { \n";
        result = result + nodeToGraph(root);
        result = result + "}";
        PrintWriter graph = null;
        try {
            graph = new PrintWriter(new FileWriter("exercise/BSTreeImage/graph.dot"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        graph.println(result);
        graph.close();
        // dot -Tpdf graph.dot -o graph.pdf
    }

    private String nodeToGraph(Node here) {
        String rtn;
        String rtn1, rtn2, rtn3;
        String tmp;
        if ( here.element == null ) {
            rtn1 = "";
        } else {
            if ( here.left == null ) {
                tmp = "";
            } else if (here.left.element == null) {
                tmp = "";
            } else {
                tmp = here.element.toString() + " -> " + here.left.element.toString() + "\n";
            }
            if ( here.right == null ) {
                rtn1 = tmp +  "";
            } else if ( here.right.element == null) {
                rtn1 = tmp + "";
            } else {
                rtn1 = tmp + here.element.toString() + " -> " + here.right.element.toString() + "\n";
            }
        }
        rtn2 = (here.left == null ? "" : nodeToGraph(here.left));
        rtn3 = (here.right == null ? "" : nodeToGraph(here.right));
        rtn = rtn1 + rtn2 + rtn3;
        return rtn;
    }

    public static void main(String[] args) {
        BSTree<Integer> myTree = new BSTree<>();
        myTree.add(4);
        myTree.add(7);
        myTree.add(1);
        myTree.add(3);
        myTree.add(9);
        myTree.add(0);
        myTree.add(5);
        myTree.toGraph();
    }
}
