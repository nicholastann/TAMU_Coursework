
#include "sort.h"
#include <iostream>
#include <vector>

void
SelectionSort::sort(vector<int>& A, int size)				// main entry point
{
	int minIndex, temp;
    for(int x = 0; x<size-1; x++)
	{
        minIndex = x;
        for(int y = x+1; y<size; y++)
		{
            if( (num_cmps++, A[y] < A[minIndex]))
			{
                minIndex = y;
            }
        }
        if(minIndex!=x){
            temp = A[x];
            A[x] = A[minIndex];
            A[minIndex] = temp;
        }
    }
}
