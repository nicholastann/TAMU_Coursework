/* 
    
	This file implements the functions of mutex.hpp
*/

#include "mutex.hpp"
#include<pthread.h>

//constructor
Mutex::Mutex()
{
	pthread_mutex_init(&m,NULL);
}
//destructor
Mutex::~Mutex()
{
	pthread_mutex_destroy(&m);
}
//Lock()
void Mutex::Lock()
{
	pthread_mutex_lock(&m);
}
//Unlock()
void Mutex::Unlock()
{
	pthread_mutex_unlock(&m);
}
