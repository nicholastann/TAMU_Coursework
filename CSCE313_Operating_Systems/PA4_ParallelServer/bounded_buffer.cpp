/* 

	This file implements the functions of bounded_buffer.hpp
*/

#include "bounded_buffer.hpp"
//Make it thread safe
//Produce
void bounded_buffer::Produce(string item)
{
	empty.P();
	m.Lock();
	buff.push(item);
	m.Unlock();
	full.V();
}
//Consume
string bounded_buffer::Consume()
{
	full.P();
	m.Lock();
	string temp;
	temp = buff.front();
	buff.pop();
	m.Unlock();
	empty.V();
	return temp;
}
