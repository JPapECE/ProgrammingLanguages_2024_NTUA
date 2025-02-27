from sys import argv
from collections import deque

f = open(argv[1],'r')
N = int(next(f))
arr = (list(map(int,next(f).split())))
f.close()


totalsum = sum(arr)
mindif = totalsum
i = 0
j = 0
sums = [0]
partial = 0
for k in arr:
    partial += k
    sums.append(partial)


   
while(i <=N and j <= N):
    mysum  = sums[i] - sums[j]
    dif = totalsum - mysum
    dif -= mysum
    
    if(dif < mindif and dif >=0): 
        mindif =  dif
        i +=1
    elif(dif < mindif and dif< 0 ):
        j +=1
        mindif = min(mindif, abs(dif))
    else:
         i += 1

       
print(mindif)