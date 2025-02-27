package ΕΧ2.Moves_java;
import java.util.LinkedList;
import java.util.List;

public class Node {
    int posx;
    int posy;
    int cost;
    int pathLength = Integer.MAX_VALUE;
    boolean visited = false;
    Node prNode = null;
    private List<Node> neighbours = new LinkedList<>();
    public Node(int x, int y, int c){
        this.cost = c;
        this.posx = x;
        this.posy = y;
    }

    public boolean getVisited(){
        return visited;
    }
    public int getCost() {
        return cost;
    }
    public int getPosx() {
        return posx;
    }
    public int getPosy() {
        return posy;
    }
    public List<Node> getNeighbours() {
        return neighbours;
    }
    public int getPathLength() {
        return pathLength;
    }
    public Node getPrNode() {
        return prNode;
    }
    public void setVisited(boolean status){
        this.visited = status;
    }
    public void setCost(int cost) {
        this.cost = cost;
    }
    public void setPosx(int posx) {
        this.posx = posx;
    }
    public void setPosy(int posy) {
        this.posy = posy;
    }
    public void setNeighbours(List<Node> neighbours) {
        this.neighbours = neighbours;
    }
    public void setPathLength(int pathLength) {
        this.pathLength = pathLength;
    }
    public void setPrNode(Node prNode) {
        this.prNode = prNode;
    } 


    public void getPath(Node end){
       /* Node start = this;
        List<Node>ns = start.getNeighbours();
        for(int k = 0; k < ns.size(); k++){
            Node v =ns.get(k);
            if(v == end && v.getCost() < start.getCost()){
                if(v.getPathLength() > start.getPathLength()+1){
                    v.setPathLength(start.getPathLength()+1);
                    v.setPrNode(start);
                }
                return;
            }

            if(v.getCost() >= start.getCost()) continue;
            else{
                if(v.getPathLength() > start.getPathLength()+1){
                    v.setPathLength(start.getPathLength()+1);
                    v.setPrNode(start);
                    v.getPath(end);
                }
            }
        } */ 
    }
}  // End of class Node