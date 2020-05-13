/* 
    File: mutex_guard.cpp

    mutex_guard.hpp
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
