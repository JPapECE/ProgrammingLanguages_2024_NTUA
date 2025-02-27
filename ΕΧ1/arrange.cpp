#include <fstream>
using namespace std;
struct node { /* recursive node definition*/
    int info;
    node *left;
    node *right;
};

node* swapN(node* n){ /*swaps the children of a node n*/
    node* temp = n->left;
    n->left = n->right;
    n->right = temp;
    return n;
}


bool isLeaf(node* n){ /*checks if the node is a leaf*/
    return(n->left == nullptr && n->right == nullptr) ;
}
int minleaf(node * n){ /* checks the children of a node to see which one has the smallest numbered leaf*/
    if(isLeaf(n)) return n->info;
    if( n->left ==nullptr) return min(n-> info, minleaf(n->right));
    if(n->right == nullptr) return min(n->info, minleaf(n->left));
    return min(minleaf(n->left), minleaf(n->right));

}

void inorder(node* n){ /*classic inorder function*/
    if(n == nullptr)return;
    inorder(n->left);
    printf("%d ", n->info);
    inorder(n->right);
}
node* prein(node *n , int *(&inf)){ /* recursive insert function that takes an array with the elements in preorder as input and then creates a tree*/
    node* p = new node;
    if(*inf == 0){ return nullptr;} 
    p->info = *inf;

    p->left = prein(p, (++inf));
    p->right = prein(p, (++inf));
    return p;

}
node* fix(node* n){ /* this is the function that balances the tree so that when you call inorder it is in the correct lexicographic order*/
    if(n == nullptr) return nullptr;
    if(n->left == nullptr && n->right == nullptr) return n;
    if(n->left == nullptr && n->right != nullptr){
        if(n-> info > minleaf(n->right)) {
            n = swapN(n);
            n->left = fix(n->left);
            n->right = nullptr;
        }
        else {
            n->right = fix(n->right);
            n->left = nullptr;
        }	
        return n;
    }
    if(n->right == nullptr && n->left != nullptr) {
        if(n-> info < minleaf(n->left)) {
            n = swapN(n);
            n->right = fix(n->right);
            n->left = nullptr;
        }
        else{
            n->left = fix(n->left);
            n->right = nullptr;
        }
        return n;
    }
    else{
        if(minleaf(n->right)< minleaf(n->left)) n = swapN(n);
        n->left = fix(n->left);
        n->right = fix(n->right);
        return n;
    }

    return n;
}


int main (int argc, char ** argv){
    int n = 0;

    ifstream infile;
    infile.open(argv[1]);
    infile>>n;

    int* arr = new int [2*n+1];
    int i = 0, info =0;

    while(i < 2*n+1){

        infile>>info;

        arr[i++] = info;        
    }
    node* root = new node;
    root->left = nullptr;
    root->right = nullptr;
    root->info = 1;
    int * aux =arr;

    root = prein(root, aux);

    root = fix(root);

    inorder(root);
    printf("\n");
    delete [] arr; 
}