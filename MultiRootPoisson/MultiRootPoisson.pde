int w = 1000;
int h = 800;
float stepSz = 20.0;

 
TreeNode root;
ArrayList<TreeNode> open = new ArrayList<TreeNode>();

void setup() 
{
  size(1000, 800);
  frameRate(1000);
  root = new TreeNode(null, null);
  new TreeNode(new PVector(w/2, h/2), root);  // Add a node at center by default
}

void draw() 
{
  background(51);
  
  if(!open.isEmpty()){
    int randIdx = (int)random(open.size());
    TreeNode randOpen = open.get(randIdx);
    open.remove(randOpen);
    randOpen.expand();
  }
    
  root.draw();
}

void mouseClicked(){
  new TreeNode(new PVector(mouseX, mouseY), root);
}

class TreeNode{
  public PVector p;
  private ArrayList<TreeNode> children;
  
  public TreeNode(PVector p, TreeNode parent){
    this.children = new ArrayList<TreeNode>();
    this.p = p;
    if(parent!=null) parent.children.add(this);
    if(p!=null) open.add(this);
  }
  
  public float distance(PVector p){
     if(this.p==null) return 10000;
     return this.p.dist(p);
  }
  
  public void expand(){
    int attempts = 5;
    for(int a=0; a<attempts; a++){
      PVector v = p; 
      while(this.distance(v)>stepSz || this.distance(v)<stepSz/2)
        v = new PVector(p.x+random(-stepSz, stepSz), p.y+random(-stepSz, stepSz));
      
      TreeNode nearest = root.findNearest(v);
      if(nearest.distance(v)>stepSz/2){
        new TreeNode(v, this); 
      }
    }
  }
  
  public TreeNode findNearest(PVector n){
    TreeNode minTree = this;
    for(TreeNode child: children){
      TreeNode childMin = child.findNearest(n);
      if(childMin.distance(n) < minTree.distance(n))
        minTree = childMin;
    }
    return minTree;
  }
  
  public void draw(){
    stroke(255);
    for(TreeNode child: children){
      if(this.p!=null)
        line(p.x, p.y, child.p.x, child.p.y);
      child.draw();
    }
    
    if(open.indexOf(this)>=0)
      fill(40, 240, 40);
    else
      fill(240, 40, 40);
    if(p!=null)
      ellipse(p.x, p.y, 5, 5);
    
  }
}