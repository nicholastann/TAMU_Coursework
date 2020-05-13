
#include "sort.h"
#include <vector>
void 
BubbleSort::sort(vector<int>& A, int size)			// main entry point
{
  int temp;
    for(int i = 1; i<A.size(); i++){
		 bool cont = false;
        for(int j = 0; j<A.size()-i; j++)
		{
            if((num_cmps++, A[j+1] < A[j]))
			{
                temp = A[j];
                A[j] = A[j+1];
                A[j+1] = temp;
				cont = true;
            }
        }
		if(!cont)
		{
			break;
		}
    }
}
