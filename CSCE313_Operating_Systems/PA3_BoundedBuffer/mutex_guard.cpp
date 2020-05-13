/* 
    File: mutex_guard.cpp

	This file implements functions in mutex_guard.hpp
*/

#include "mutex_guard.hpp"
#include<pthread.h>


//Constructor
MutexGuard::MutexGuard(Mutex &m)
{
	m.Lock();
}
//Destructor
MutexGuard::~MutexGuard()
{
	m->Unlock();
}
