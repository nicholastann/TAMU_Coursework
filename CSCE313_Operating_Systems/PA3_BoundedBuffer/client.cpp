/* 

    Client main program for MP3 in CSCE 313
*/

/*--------------------------------------------------------------------------*/
/* DEFINES */
/*--------------------------------------------------------------------------*/

    /* -- (none) -- */

/*--------------------------------------------------------------------------*/
/* INCLUDES */
/*--------------------------------------------------------------------------*/

#include <cassert>
#include <string>
#include <iostream>
#include <sstream>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <unistd.h>
#include <sys/time.h>
#include<assert.h>
#include "reqchannel.hpp"
#include <ctime>
#include <chrono>
#include "bounded_buffer.cpp"
#include <pthread.h>
#include <map>
#include <string>

using namespace std;

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
/* LOCAL FUNCTIONS -- SUPPORT FUNCTIONS */
/*--------------------------------------------------------------------------*/

std::string int2string(int number) {
  std::stringstream ss;//create a stringstream
   ss << number;//add number to the stream
   return ss.str();//return a string with the contents of the stream
}

string Extract_Name(string request) //extracts name from the data requests
{
	int pos = request.find(" ");
	string name = request.substr(pos+1);
	return name;
}

struct RTArgs{
	bounded_buffer* WPC;
	string patient_name;
	int Nrequests;
};

struct WTArgs{
	bounded_buffer* WPC;
	RequestChannel* Chan;
	map<string,bounded_buffer*> PCMap;
};

struct STArgs
{
	bounded_buffer* PCB;
	string name;
	int Nreq;
	Mutex* mu;
};

void* Req_TH_Func(void * addr)
{
	RTArgs* args = (RTArgs*) addr;
	for(int i=0;i<args->Nrequests;i++)
	{
		args->WPC->Produce("data "+args->patient_name);
	}
}

void* Wor_TH_Func(void * addr)
{
	WTArgs* args = (WTArgs*) (addr);
	bool stop = false;
	while(!stop)
	{
		//Consume from the PCbuffer
		string request = args->WPC->Consume();
		//cout<<request<<endl;
		if(request == "quit")
		{
		string response = args->Chan->send_request(request);
		//chain the quit command
		args->WPC->Produce(request);
		stop = true;
		break;
		}
		string response = args->Chan->send_request(request);
		//Distinguish data for each patient_name
		string patient_name = Extract_Name(request);
		//then place the response into respective pcbuffer for each patient_name
		args->PCMap.find(patient_name)->second->Produce(response);
	}
}

void* STFunc(void* addr)
{
	int count =0;
	STArgs* args = (STArgs*) addr;
	vector<int> Histogram(10);
	for(int i=0;i<args->Nreq;i++)
	{
		//get the data from the PCB 
		string response  = args->PCB->Consume();
		//convert string to integer
		stringstream stream(response);
		int x=0;
		stream >> x;
		if(x>=0 && x <100)
		{
			count++;
		}
		//update histogram
		if (x >=0 && x <10){Histogram[0]++; }
		else if (x >=10 && x<20) {Histogram[1]++; }
		else if (x >=20 && x<30) {Histogram[2]++; }
		else if (x >=30 && x<40) {Histogram[3]++; }
		else if (x >=40 && x<50) {Histogram[4]++; }
		else if (x >=50 && x<60) {Histogram[5]++; }
		else if (x >=60 && x<70) {Histogram[6]++; }
		else if (x >=70 && x<80) {Histogram[7]++; }
		else if (x >=80 && x<90) {Histogram[8]++; }
		else if (x >=90 && x<100) {Histogram[9]++; }
	}
	
	//Thread safe printing to console
	args->mu->Lock();
	//print name;
	cout<<"Histogram for "<<args->name<<endl;
	//print histogram
	cout<< "00-09: "<<Histogram[0]<<endl;
	cout<< "10-19: "<<Histogram[1]<<endl;
	cout<< "20-29: "<<Histogram[2]<<endl;
	cout<< "30-39: "<<Histogram[3]<<endl;
	cout<< "40-49: "<<Histogram[4]<<endl;
	cout<< "50-59: "<<Histogram[5]<<endl;
	cout<< "60-69: "<<Histogram[6]<<endl;
	cout<< "70-79: "<<Histogram[7]<<endl;
	cout<< "80-89: "<<Histogram[8]<<endl;
	cout<< "90-99: "<<Histogram[9]<<endl;
	cout<<"Number of total responses"<<count<<endl;
	args->mu->Unlock();
}

/*--------------------------------------------------------------------------*/
/* MAIN FUNCTION */
/*--------------------------------------------------------------------------*/

int main(int argc, char * argv[]) {

  int pid = fork();
  if(pid==0) //if child execute the dataserver 
  {
	  execl("dataserver", (char*) NULL);
  }
  else
  {
	extern char* optarg;
	int opt;
	//default arguments
	int num_of_data_requests = 10;
	int size_of_buffer = 50;
	int num_of_worker_threads = 10;
	while((opt = getopt(argc, argv, "n:b:w:")) != -1){//while loop with swictch for parsing of command line
	  switch (opt)
	  {
		case 'n':
				num_of_data_requests = atoi(optarg);
				break;
		case 'b':
				size_of_buffer = atoi(optarg);
				break;
		case 'w':
				num_of_worker_threads = atoi(optarg);
				break;
		case '?':
				cout<<"Only use this format: ./memtest -n <number of data requests per patient> -b <size of bouned buffer> -w <number of worker threads> \n";
	  }
	}
	 //Creating one buffer for the request threads and the worker threads to produce and consume.
	  bounded_buffer WPC(size_of_buffer);
	  
	  //Bounded buffers for each statistic thread
	  bounded_buffer SPC(size_of_buffer); // one bounded buffer for John Doe for statistics
	  bounded_buffer SPC1(size_of_buffer); // one bounded buffer for Jane Smith for statistics
	  bounded_buffer SPC2(size_of_buffer);// one bounded buffer for Joe Smith for statistics
	  
	  //Creating the request threads, one for each patient 
	  //John
	  RTArgs P1;
	  P1.WPC = &WPC;
	  P1.Nrequests = num_of_data_requests;
	  P1.patient_name = "John";
	  pthread_t P1ReqThread;
	  pthread_create(&P1ReqThread,NULL,Req_TH_Func,(void*)&P1);
	  
	  //Jane
	  RTArgs P2;
	  P2.WPC = &WPC;
	  P2.Nrequests = num_of_data_requests;
	  P2.patient_name = "Jane";
	  pthread_t P2ReqThread;
	  pthread_create(&P2ReqThread,NULL,Req_TH_Func,(void*)&P2);
	  
	  //Joe
	  RTArgs P3;
	  P3.WPC = &WPC;
	  P3.Nrequests = num_of_data_requests;
	  P3.patient_name = "Joe";
	  pthread_t P3ReqThread;
	  pthread_create(&P3ReqThread,NULL,Req_TH_Func,(void*)&P3);
	  
	  //Creating PCMap
	  map<string,bounded_buffer*> SPCBMap;
	  SPCBMap["John"] = &SPC;
	  SPCBMap["Jane"] = &SPC1;
	  SPCBMap["Joe"] = &SPC2;
	  
	  //Creating control thread
	  std::cout << "CLIENT STARTED:" << std::endl;
	  std::cout << "Establishing control channel... " << std::flush;
	  RequestChannel chan("control", RequestChannel::CLIENT_SIDE);
	  std::cout << "done." << std::endl;
	  
	  //Creating worker threads
	  pthread_t* WorkerThreads = new pthread_t[num_of_worker_threads];
	  WTArgs* ThreadData = new WTArgs[num_of_worker_threads];
	  for(int i=0;i< num_of_worker_threads;i++)
	  {
		ThreadData[i].PCMap = SPCBMap;
		string channelName = chan.send_request("newthread");
		RequestChannel* newchan = new RequestChannel(channelName, RequestChannel::CLIENT_SIDE);
		ThreadData[i].Chan = newchan;
		ThreadData[i].WPC = &WPC;
		pthread_create(WorkerThreads+i,NULL,Wor_TH_Func,(void*)(ThreadData+i));
	  }
	  
	  //Creating a mutex lock for printing the histograms
	  Mutex m;
	  
	  //Creating Arguments for the statistic threads 
	  STArgs statForJohn;
	  statForJohn.PCB = &SPC;
	  statForJohn.name = "John";
	  statForJohn.Nreq = num_of_data_requests;
	  statForJohn.mu = &m;
	  STArgs statForJane;
	  statForJane.PCB = &SPC1;
	  statForJane.name = "Jane";
	  statForJane.Nreq = num_of_data_requests;
	  statForJane.mu = &m;
	  STArgs statForJoe;
	  statForJoe.PCB = &SPC2;
	  statForJoe.name = "Joe";
	  statForJoe.Nreq = num_of_data_requests;
	  statForJoe.mu = &m;
	  
	  //Creating Statistics threads, one for each patient 
	  pthread_t John;
	  pthread_t Jane;
	  pthread_t Joe;
	  pthread_create(&John,NULL,STFunc, (void*)&statForJohn);
	  pthread_create(&Jane,NULL,STFunc, (void*)&statForJane);
	  pthread_create(&Joe,NULL,STFunc, (void*)&statForJoe);
	  
	  //wait for all request threads to finish
	  pthread_join(P1ReqThread,NULL); //waiting for request thread of John's
	  pthread_join(P2ReqThread,NULL); //waiting for request thread of Jane's
	  pthread_join(P3ReqThread,NULL); //waiting for request thread of Joe's
	  
	  //Once all request threads finish chain a quit command 
	  WPC.Produce("quit");
	  
	  //Wait for all the worker threads to finish
	  for(int i=0;i<num_of_worker_threads;i++)
	  {
		pthread_join(WorkerThreads[i],NULL);
	  }
	  
	  //wait for all the statistics threads to finish
	  pthread_join(John,NULL); //waiting for stat thread of John's
	  pthread_join(Jane,NULL); //waiting for request thread of Jane's
	  pthread_join(Joe,NULL); //waiting for request thread of Joe	's
	  
	  
	  //Close the Control Channel	
	  cout<<"Finished!\n";
	  std::string reply4 = chan.send_request("quit");
      std::cout << "Reply to request 'quit' is '" << reply4 << std::endl;
  }
}
