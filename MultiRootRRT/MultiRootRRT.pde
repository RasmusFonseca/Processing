int w = 1000;
int h = 800;
float stepSz = 7.0;
 
TreeNode root;

void setup() 
{
  size(1000, 800);
  frameRate(1000);
  root = new TreeNode(new PVector(w/2, h/2), null);
}

void draw() 
{
  background(51);
  
  PVector randVec = new PVector(random(0,w), random(0,h));
  TreeNode min = root.findNearest(randVec);
  if(min.p==null) return;
  PVector diff = PVector.sub(randVec, min.p);
  diff.normalize();
  diff.mult(stepSz);
  new TreeNode(PVector.add(min.p, diff), min);
  
  stroke(255);
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
  }
  
  public float distance(PVector p){
     if(this.p==null) return 10000;
     return this.p.dist(p);
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
     for(TreeNode child: children){
       if(this.p!=null)
         line(p.x, p.y, child.p.x, child.p.y);
       child.draw();
     }
  }
}