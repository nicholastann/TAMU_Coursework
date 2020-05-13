/* 
   

	This file implements the functions of a typical semaphore.
*/

#include "semaphore.hpp"

using namespace std;

//Constructor
Semaphore::Semaphore(int _val)
{
	pthread_mutex_init(&m,NULL);
	pthread_cond_init(&c,NULL);
	value = _val;
}
//Destuctor
Semaphore::~Semaphore()
{
	pthread_mutex_destroy(&m);
	pthread_cond_destroy(&c);
}

//P()

int Semaphore::P()
{
	pthread_mutex_lock(&m);
	value--;
	if(value<0)
	{
		pthread_cond_wait(&c,&m);
	}
	pthread_mutex_unlock(&m);
}

//V()
int Semaphore::V()
{
	pthread_mutex_lock(&m);
	value++;
	if(value<=0)
	{
		pthread_cond_signal(&c);
	}
	pthread_mutex_unlock(&m);
}

