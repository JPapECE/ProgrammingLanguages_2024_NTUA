#include <stdio.h>
#include <stdlib.h>

int min(int a , int b){
    return(a<b) ? a : b;/*if a<b return a else return b*/
}

int main(int argc , char** argv){

    if(argc != 2){
        printf("Wrong arguments\n");
        return 1;
    }

    FILE* inputfile = fopen(argv[1], "r"); /*open the file from command line for reading*/

    if(!inputfile){/*error*/
        printf("cannot open reading file\n");
        return 1;
    }

    int N;/*the size of the subsequence*/
    int n = fscanf(inputfile , "%d", &N);
    if(n != 1)
        printf("bad scanf from the array size\n");
    

    int arr[N+1];/*an array to store prefix sums*/

    arr[0] = 0;
    for(int i = 1; i< N+1; i++){
        n = fscanf(inputfile,"%d", &arr[i]);/*reads the i-th value of the subsequence*/
        if(n != 1)
            printf("bad scanf for the %d-th value\n", i);

        arr[i] = arr[i]+ arr[i-1];/*stores the prefix sum for each value*/
    }

    fclose(inputfile);

    int total_sum = arr[N]; /*store the total sum of all values in a separate int*/

    int minimum_dif = total_sum;/*here we store the desired minimum differnce ,we are starting fom the max value it can take (total_sum)*/
    int i = 0;/*an iterator pointing at the end of the subsequence*/
    int j = 0;/*an iterator pointing at the start of the subsequence*/

    while(i < N && j < N){
        int sum = arr[i] - arr[j];/*we store the partial sum of the subseq*/
        int dif = total_sum - sum;/*now in int dif we store the sum of the remaining sequence*/
        dif -= sum;/*now we store the difference of the two sums*/

        if(dif < minimum_dif && dif >= 0) {
            minimum_dif = dif;/*if you find a smaller difference keep it*/
            i++;/*extend the subseq we may find smth even smaller*/
        }
        else if(dif < minimum_dif && dif < 0){
            j++;/*we went too far so start omit a value from the start*/
            minimum_dif = min(minimum_dif , abs(dif));/*before moving on we have to check if this different is smaller*/
        }
        else/*continue searching*/
            i++;	

    }
    
    
    printf("%d\n",minimum_dif);

    return 0;
}