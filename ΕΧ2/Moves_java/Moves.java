package ΕΧ2.Moves_java;

import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Scanner ;
import java.io.*;

public class Moves {
    public static <T> void revlist(List<T> list) //From geeks for geeks
    {
        // base condition when the list size is 0 
        if (list.size() <= 1 || list == null)
            return;
 
       
        T value = list.remove(0);
       
        // call the recursive function to reverse 
        // the list after removing the first element 
        revlist(list);
 
        // now after the rest of the list has been 
        // reversed by the upper recursive call, 
        // add the first value at the end
        list.add(value);
    } //end of code from geeks for geeks
    static Node bfs(Node startNode, Node endNode)
    {
        // Create a queue for BFS
        Queue<Node> queue = new LinkedList<>();
      

        // Mark the current node as visited and enqueue it
        startNode.setVisited(true);
        queue.add(startNode);

        // Iterate over the queue
        while (!queue.isEmpty()) {
            // Dequeue a vertex from queue and print it
            Node currentNode = queue.poll();
            for (Node neighbor : currentNode.getNeighbours()) {
                if(currentNode.getCost() <= neighbor.getCost()) continue;
                if(neighbor.getPathLength()<= currentNode.getPathLength()+1) continue;
                neighbor.setPrNode(currentNode);
                neighbor.setPathLength(neighbor.getPathLength()+1);
                if (!neighbor.getVisited()) {
                    neighbor.setVisited(true);
                    queue.add(neighbor);
                }
                if(neighbor == endNode) return neighbor;
            }
        }
        return startNode;
    }
    public static void main(String[] args){
        String[][] coor = new String[3][3];
        coor[0][0] = "NW";
        coor[0][1] = "N";
        coor[0][2] = "NE";
        coor[1][0] = "W";
        coor[1][1] = "error";
        coor[1][2] = "E";
        coor[2][0] = "SW";
        coor[2][1] = "S";
        coor[2][2] = "SE";        
        try{
            File file = new File(args[0]);
            Scanner in = new Scanner(file);
        
        
        
            int n = in.nextInt();
            Node[][] grid = new Node[n][n];
            for(int i = 0; i < n ; i ++){
                for(int j = 0; j < n; j++){
                    int c = in.nextInt();
                    Node p = new Node(i, j, c);
                    grid[i][j] = p;
                }
            }
            in.close();
            for(int i = 0; i < n ; i ++){
                for(int j = 0; j < n; j++){                
                List<Node> neighbours = new LinkedList<>();
                
                if( i - 1 >= 0){
                        if(j -1 >= 0) {neighbours.add(grid[i-1][j-1]);}
                        neighbours.add(grid[i-1][j]);
                        if(j +1 <= n-1) neighbours.add(grid[i-1][j+1]);
                        
                }

                if(j -1 >= 0) neighbours.add(grid[i][j-1]);
                if(j +1 <= n-1) neighbours.add(grid[i][j+1]);

                if( i + 1 <= n-1){
                        if(j -1 >= 0) neighbours.add(grid[i+1][j-1]);
                        neighbours.add(grid[i+1][j]);
                        if(j +1 <= n-1) neighbours.add(grid[i+1][j+1]);
                    }

                    grid[i][j].setNeighbours(neighbours);
            }
   
            }
            grid[0][0].getPath(grid[n-1][n-1]);
            Node temp= bfs(grid[0][0], grid[n-1][n-1]);
            if(temp == grid[0][0]){
                System.out.println("IMPOSSIBLE");
                return;
            }
            List<String> finalPath = new LinkedList<>();
            while (temp != grid[0][0]) {
                Node pr =temp.getPrNode();
               
                finalPath.add(coor[1+temp.getPosx() -pr.getPosx()][1+ temp.getPosy() -pr.getPosy()]);
                temp = pr;   
            }
            
            revlist(finalPath);
            System.out.println(finalPath);

        }
        catch(FileNotFoundException ex){
            return;
        }
    }
    
    
} 
