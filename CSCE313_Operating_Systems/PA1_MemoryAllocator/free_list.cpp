

/*--------------------------------------------------------------------------*/
/* DEFINES */
/*--------------------------------------------------------------------------*/

    /* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* INCLUDES */
/*--------------------------------------------------------------------------*/

#include <iostream>
#include "free_list.hpp"

/*--------------------------------------------------------------------------*/
/* NAME SPACES */ 
/*--------------------------------------------------------------------------*/

using namespace std;
/* I know, it's a bad habit, but this is a tiny program anyway... */

/*--------------------------------------------------------------------------*/
/* DATA STRUCTURES */ 
/*--------------------------------------------------------------------------*/

    /* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* CONSTANTS */
/*--------------------------------------------------------------------------*/

    /* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* FORWARDS */
/*--------------------------------------------------------------------------*/

    /* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* FUNCTIONS FOR CLASS SegmentHeader */
/*--------------------------------------------------------------------------*/

SegmentHeader::SegmentHeader(size_t _length, bool _is_free, bool inh1, bool is_left1) {
  length = _length;
  is_free = _is_free;
  cookie = COOKIE_VALUE;
  // You may need to initialize more members here
  next = NULL;
  prev  = NULL;
  is_left = is_left1;
  inh = inh1;
}

SegmentHeader::~SegmentHeader() {
  // You may need to add code here.
}


void SegmentHeader::CheckValid() {
  if (cookie != COOKIE_VALUE) {
    cout << "INVALID SEGMENT HEADER!!" << endl;
    assert(false);
    // You will need to check with the debugger to see how we got into this
    // predicament.
  }
}

/*--------------------------------------------------------------------------*/
/* FUNCTIONS FOR CLASS FreeList */
/*--------------------------------------------------------------------------*/

FreeList::FreeList(int length) {
  header = nullptr;//initialize header to null pointer
  size = 0;
  fib_num = length;
}

FreeList::~FreeList() {
  //Piazza post: Leave empty as the destructor of myallocator takes care of it
}

bool FreeList::Add(SegmentHeader * _segment) {
	if(header == nullptr)//if header is null then point to seg
	{
		header  = _segment;
		size++;
		return true;
	}
	else //else just add to beginnig of freelist
	{
		_segment->next = header;
		header->prev = _segment;
		header = _segment;
		size++;
		return true;
	}
}

bool FreeList::Remove(SegmentHeader * _segment) {
	if(_segment == header)//if segment is header
	{
		header = _segment->next;
		if(_segment->next != NULL)
		{
			_segment->next->prev = NULL;
		}
		_segment->is_free = false;
		_segment->next = NULL;
		_segment->prev = NULL;
		size--;
		return true;
	}
	else if(_segment->prev != NULL && _segment->next == NULL)//if segment is tail 
	{
		_segment->prev->next = NULL;
		_segment->prev= NULL;
		_segment->next = NULL;
		_segment->is_free = false;
		size--;
		return true;
	}
	else//segment is in between two segments
	{
		_segment->prev->next = _segment->next;
		_segment->next->prev = _segment->prev;
		_segment->prev = NULL;
		_segment->next =NULL;
		_segment->is_free = false;
		size--;
		return true;
	}
}
