//NAME: AMMAAR AHMAD
//ROLL: 1801CS08
//I DECLARE THAT IT'S MY OWN WORK
#include <bits/stdc++.h>
#include <fstream>
using namespace std;
struct opcode 			//instruvtion set architecture definiton
{
	string mnemonic;
	string operand;
};
int main(int argc, char** argv)
{
	int memory[0x100000]={0};			//memory used for execution of program
	if(argc==2)							// if no instruction is passed to emulator
	{	
		printf("-trace show instruction trace\n");
		printf("-isa show mnemonic and expected operands\n");
		printf("-after show memory dump after execution\n");
		printf("-before show memory dump before execution\n");
		return 0;
	}
	string input = argv[2];				//object filename
	string type = argv[1];				//instruction type
	opcode arr[21]={{"ldc","value"},{"adc","value"},{"ldl","offset"},
	{"stl","offset"},{"ldnl","offset"},{"stnl","offset"},{"add",""},
	{"sub",""},{"shl",""},{"shr",""},{"adj","value"},{"a2sp",""},{"sp2a",""},
	{"call","offset"},{"return",""},{"brz","offset"},{"brlz","offset"},
	{"br","offset"},{"halt",""},{"data","value"},{"set","value"}};
	ifstream fin(input, ios::binary);	//reading machine code in binary mode
	int n=0, error=0;
	while(fin)								//read until end of file
		fin.read((char*)&memory[n++], 4);
	n--;
	if(type=="-before")					//before execution memory dump
	{
		int k=0;
		while(k<n)
		{	
			printf("%08X\t%08X\n",k, memory[k]);
			k++;
		}
	}
	else if(type=="-trace" || type=="-after")		//execution of instructions
	{
		int num=0, cnt=0, rem=0, t=0;
		int A=0, B=0, PC=0, SP=4096;
		while(true)									//executing line by line
		{
			if(PC>=n)								// PC location exceeds memory read then break with segmentation fault
			{
				printf("Segmentation Fault\n");
				break;
			}
			num=memory[PC];							//fetching machine code
			rem=num&255;							//fetching opcode
			num=num-rem;							
			num=num/256;							//operand
			if(type=="-trace")						// if tracing print every line
			{
				printf("PC=%08X, SP=%08X, A=%08X, B=%08X ",PC,SP,A,B);
				if(arr[rem].operand!="")
				{
					cout<<arr[rem].mnemonic;
					printf(" %08X\n",num);
				}
				else
					cout<<arr[rem].mnemonic<<endl;
			}
			if(rem>18)
			{
				printf("ERROR: Unknown Opcode %d\n",rem);	//If opcode is greater than 18(decimal)
				error=1;
				break;
			}
			if(rem==18)								// if halt stop execution
				break;
			else if(rem==0)							//ldc
			{
				B=A;
				A=num;
			}
			else if(rem==1)							//adc
				A=A+num;
			else if(rem==2)							//ldl
			{
				B=A;
				A=memory[SP+num];
			}
			else if(rem==3)							//stl
			{
				memory[SP+num]=A;
				A=B;
			}
			else if(rem==4)							//ldnl
				A=memory[A+num];		
			else if(rem==5)							//stnl
				memory[A+num]=B;
			else if(rem==6)							//add
				A=B+A;
			else if(rem==7)							//sub
				A=B-A;
			else if(rem==8)							//shl
				A=B<<A;
			else if(rem==9)							//shr
				A=B>>A;
			else if(rem==10)						//adj
				SP=SP+num;	
			else if(rem==11)						//a2sp
			{
				SP=A;
				A=B;
			}
			else if(rem==12)						//sp2a
			{
				B=A;
				A=SP;
			}
			else if(rem==13)						//call
			{
				B=A;
				A=PC;
				PC=PC+num;
			}
			else if(rem==14)						//return
			{
				PC=A;
				A=B;
			}
			else if(rem==15 && A==0)				//brz
				PC=PC+num;
			else if(rem==16 && A<0)					//brlz
				PC=PC+num;
			else if(rem==17)						//br
				PC=PC+num;
			cnt++;
			PC++;									//increment of PC after each execution
		}
		printf("%d instructions executed\n",cnt);
		if(error==0 && type=="-after")							//memory dump after execution
		{
			int k=0;
			while(k<n)
			{	
				printf("%08X\t%08X\n",k, memory[k]);
				k++;
			}
		}
	}
	else if(type=="-isa")							//printing instruction set architecture
	{
		cout<<"Opcode\tMnemonic\tOperand\n";
		for(int i=0; i<=20; i++)
			cout<<i<<"\t"<<arr[i].mnemonic<<"\t\t"<<arr[i].operand<<endl;
	}
	else											//if unkonwn operarion is passed print valid operation
	{
		printf("-trace show instruction trace\n");
		printf("-isa show mnemonic and expected operands\n");
		printf("-after show memory dump after execution\n");
		printf("-before show memory dump before execution\n");
	}
}