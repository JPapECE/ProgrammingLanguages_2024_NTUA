from sys import argv
from collections import deque
#import time
#start_time = time.time()


f = open(argv[1],'r')
Grid = []
N = int(next(f))
for line in f:
    Grid.append(list(map(int,line.split())))
f.close()


nodes = deque([(0,0)])
prev = {(0,0): None}
path = {(0,0): None}
dist = {(0, 0): 0}

def isFinal(node):
    return node == (N-1,N-1)

#dummy solver
def nextmove(node):
    yield (node[0]+1,node[1]),'S'
    yield (node[0]-1,node[1]),'N'
    yield (node[0],node[1]+1),'E'
    yield (node[0],node[1]-1),'W'
    yield (node[0]+1,node[1]+1),'SE'
    yield (node[0]+1,node[1]-1),'SW'
    yield (node[0]-1,node[1]+1),'NE'
    yield (node[0]-1,node[1]-1),'NW'

def isSafe(node,next):
    if next[0] < 0 or next[0] >= N or next[1] < 0 or next[1] >= N : 
        return False
    else :
        return (Grid[next[0]][next[1]]) < (Grid[node[0]][node[1]])


def bfs():
    while nodes:
        current = nodes.popleft()
        current_distance = dist[current]
        for next_node,move in nextmove(current):
            if not isSafe(current,next_node):
                continue
            if next_node in dist and dist[next_node] <= current_distance + 1:
                continue
            dist[next_node] = current_distance + 1

            path[next_node] = move
            prev[next_node] = current
            if isFinal(next_node):
                return next_node
            nodes.append(next_node)
    return None

def printSol(final_node):
    if final_node is None:
        print("IMPOSSIBLE")
        return
    moves = []
    current_node = final_node
    while current_node != (0, 0):
        moves.append(path[current_node])
        current_node = prev[current_node]
    moves.reverse()
    print('[', end='')
    print(','.join(moves), end=']\n')
    

final = bfs()


printSol(final)
