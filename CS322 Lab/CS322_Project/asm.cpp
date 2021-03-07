//NAME: AMMAAR AHMAD
//ROLL: 1801CS08
//I DECLARE THAT IT'S MY OWN WORK AND ALL CODES ARE MY OWN
#include <bits/stdc++.h>
#include <fstream>
using namespace std;
struct codes			//structure to store 3 main parts of each of assembly language code
{
	string label;
	string mnemonic;
	string operand;
};
string trim(string s)		//function to remove leading and trailing spaces
{
	int i=0;
	while(s[i]==' ' || s[i]=='\t')
		i++;
	s=s.substr(i);
	int j=s.length();
	while(s[j-1]==' ' || s[j-1]=='\t')
		j--;
	s=s.substr(0,j);
	return s;
}
bool valid_label(string s)	//checking for validity of any label. Label should start from alphabet and be alphanumeric and underscore allowed
{
	if(s[0]<'a' || s[0]>'z')
		return false;
	for (int i=1; i<s.length(); i++)
	{
		if(s[i]=='_')
			continue;
		if(s[i]<'0' || (s[i]>'9' && s[i]<'a') || s[i]>'z')
			return false;
	}
	return true;
}
string bintohex(string t)	//converting a binary string to a hexadecimal string
{
	int l=t.length();
	char bth[16]={'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
	while(l%4>0)
	{
		t="0"+t;
		l++;
	}
	string ans; l=0;
	while(l<t.length())
	{
		int cnt=4; int num=0;
		while(cnt>0)
		{
			num=num*2+t[l]-48;
			cnt--;
			l++;
		}
		ans.push_back(bth[num]);
	}
	return ans;
}
string valid_hex(string s)		//checking whether the string is valid hexadecimal string and returning hexadecimal string (32 bits) if valid else return NULL string
{
	string ans;
	for (int i=2; i<s.length(); i++)
	{
		if((s[i]>=48 && s[i]<=57) || (s[i]>='A' && s[i]<='F') || (s[i]>='a' && s[i]<='f'))
			ans=ans+s[i];
		else
			return "";
	}
	while(ans.length()<8)
		ans="0"+ans;
	return ans;
}
string octaltohex(string s)		//checking for validity of octal string and returning hexadecimal equivalent string if valid
{
	string ans, temp;
	string a[8]={"000","001","010","011","100","101","110","111"};
	for(int i=1; i<s.length(); i++)		// converting octal to binary loop
	{
		if(s[i]>='0'&&s[i]<='7')
			temp+=a[s[i]-48];
		else
			return "";
	}	
	ans=bintohex(temp);		// calling binary to hexadecimal function
	while(ans.length()<8)
		ans="0"+ans;
	ans=ans.substr(ans.length()-8);
	return ans;
}
string decimaltohex(string s)		//checking for validity of decimal string and returning hexadecimal equivalent string if valid
{
	if(s[0]=='+')
		s=s.substr(1);
	int x=stoi(s);
	string t=to_string(x);
	if(t!=s)
		return "";
	string ans;
	for (int i=0; i<32; i++)
	{
		if(x&1)
			ans="1"+ans;
		else
			ans="0"+ans;
		x=x>>1;
	}
	ans=bintohex(ans);
	while(ans.length()<8)
		ans="0"+ans;
	return ans;	
}
int main(int argc, char **argv)	//command line argument:- name of the file
{
	string code, temp, operand, label, token, line;	//string variables
	int loc=0, start=0, length, num=1;			//integer variables
	bool error=false;					//to checkwhether there is any error. If atleast 1 error exists error variable is true
	map<string, string> opcode;				//map used for opcode
	ifstream fin1;						//input filestream
	ofstream fout1, fout2, fout3;				//output filestream
	fin1.open("opcode.txt",ios::in);			
	fin1>>code>>temp;
	while(code!="end")					//loop for storing mnemonic-opcode key value pair in map
	{
		opcode.insert({code,temp});
		fin1>>code>>temp;
	}				
	string input = argv[1];				//input filename from user
	string out1, out2, out3;				//3 output files
	size_t f=input.find('.');			
	if(f!=string::npos)
		temp=input.substr(0,f);
	else
		temp=input;
	out1=temp+".l";				
	out2=temp+".o";
	out3=temp+".log";
	fin1.close();
	fin1.open(input,ios::in);
	fout1.open(out1,ios::out);
	fout3.open(out3,ios::out);
	set <string> noop;					//storing mnemonic which has no operand in noop set
	noop.insert("add");
	noop.insert("sub");
	noop.insert("shr");
	noop.insert("shl");
	noop.insert("return");
	noop.insert("a2sp");
	noop.insert("sp2a");
	noop.insert("halt");
	set <string> offset;					//storing mnemonic which requires operand as an offset
	offset.insert("ldl");
	offset.insert("stl");
	offset.insert("ldnl");
	offset.insert("stnl");
	offset.insert("call");
	offset.insert("brz");
	offset.insert("brlz");
	offset.insert("br");
	set <string> used_label;				//keeping check of number of used labels
	vector <codes> v;					//vector to stores assembly code 3 main parts- label,mnemonic,operand
	vector <unsigned int> machine;			//machine code in integer value
	map<string, int> labels;				//map to store different label and their location in memory
	while(getline(fin1,line))				//first pass of assembly code
	{
		line = trim(line);
		f=line.find(';');
		if(f!=string::npos)
		{
			line=line.substr(0,f);
			line=trim(line);
		}
		if(line=="")
		{
			v.push_back({"", "", ""});
			num++;
			continue;
		}
		label=""; token=""; temp="";
		transform(line.begin(), line.end(), line.begin(), ::tolower);		//changing entire code into lowercase, making it case insensitive
		int ch=0;
		for (int i=0; i<=line.length(); i++)						//loop to extract label, mnemonic and operand
		{
			if(ch==0)								//checking if label is already fetched for this line 
			{
				if(i==line.length())						//just end contion of loop to fetch all information
				{
					token=line.substr(0,i);
					if(opcode.count(token)==0)
					{
						fout3<<"ERROR: Illegal mnemonic on line "<<num<<"\n";
						error=true;
						token="";
					}
					break;
				}
				if(line[i]==':')
				{
					label=line.substr(0,i);
					line=trim(line.substr(i+1));
					if(labels.count(label))
					{	
						fout3<<"ERROR: A duplicate label was found on line "<<num<<"\n";
						error=true;
					}
					else if(!valid_label(label))
					{
						fout3<<"ERROR: Invalid label name on line "<<num<<"\n";			
						error=true;
					}
					else if(opcode.count(label))
					{
						fout3<<"ERROR: label name on line "<<num<<" is a reserved mnemonic"<<"\n";	//if label is same as mnemonic reserved word
						error=true;
					}
					else
						labels.insert({label,loc});
					ch=1; i=-1;
				}
				else if(line[i]==' ' || line[i]=='\t')
				{
					token=line.substr(0,i);
					line=trim(line.substr(i+1));
					if(opcode.count(token)==0)
					{
						fout3<<"ERROR: Illegal mnemonic on line "<<num<<"\n";			//if mnemonic is invalid
						error=true;
						token="";
					}
					ch=2; i=-1;
				}
				
			}
			else if(ch==1)								// if label is fetched but not mnemonic then this part
			{
				if(i==line.length())
				{
					token=line.substr(0,i);
					if(token.length()>0 && opcode.count(token)==0)
					{
						fout3<<"ERROR: Illegal mnemonic on line "<<num<<"\n";			//if mnemonic is invalid
						error=true;
						token="";
					}
					break;
				}
				if(line[i]==' ' || line[i]=='\t')
				{
					token=line.substr(0,i);
					line=trim(line.substr(i+1));
					if(opcode.count(token)==0)
					{
						fout3<<"ERROR: Illegal mnemonic on line "<<num<<"\n";
						error=true;
						token="";
					}
					ch=2; i=-1;
				}
			}
			else if(ch==2)								//if both mnemonic and label is fetched and operand is left
			{
				if(i==line.length())
				{
					temp=line.substr(0,i);
					break;
				}
				if(line[i]==' ' || line[i]=='\t' || line[i]==',' || line[i]==':')
				{
					temp=line.substr(0,i);
					line=trim(line.substr(i+1));
					if(line.length()>0)
					{
						fout3<<"ERROR: Extra information on line "<<num<<", maybe there is mistype error"<<"\n";		//if extra information is given in particular line
						error=true;
					}
					break;
				}
			}
		}
		v.push_back({label,token,temp});						//storing code in memory for second pass
		if(token=="")
		{
			num++;
			continue;
		}
		if(token=="set" || token=="data")				// if mnemonic is SET instruction tell making desired changes in map and checking for validity of operand
		{
			if(label=="" && token=="set")
			{
				fout3<<"ERROR: MIssing label, set operation can be performed only on label"<<"\n";
				error=true;
			}
			else
			{
				if(temp=="")							// if SET instruction is without a operand
				{
					fout3<<"ERROR: operand expected on line "<<num<<"\n";
					error=true;
				}
				else
				{
					if(temp.size()>=2 && temp[0]=='0' && temp[1]=='x')				// checking if numerical value is hexadecimal
					{
						operand=valid_hex(temp);
						if(operand=="")
							error=true;	
					}
					else if(temp[0]=='0' && temp.length()>1)					// or if numerical value is octal
					{
						operand=octaltohex(temp);
						if(operand=="")
							error=true;
					}
					else if((temp[0]>='0' && temp[0]<='9') || temp[0]=='-' || temp[0]=='+')	// or if numerical value is decimal	
					{
						operand=decimaltohex(temp);
						if(operand=="")
							error=true;
					}
					else										// if it's neither of these then printing error 
					{
						fout3<<"ERROR: A non numerical value present, data or set instruction requires numeric value on line "<<num<<"\n";
						error=true;
					}
					if(operand.length()>0 && token=="set")								// changing label pointer to value itself
					{
						int tt=stoi(operand, 0, 16);
						labels[label]=tt;
					}
				}
			}
		}
		num++;
		loc++;
	}
	fin1.close();													// closing input file after reading the assembly code
	num=1; loc=0;
	for (int i=0; i<v.size(); i++)										//second pass. Using stored instructions in memory
	{
		label=v[i].label;
		token=v[i].mnemonic;
		temp=v[i].operand;
		if(label=="" && token=="" && temp=="")								// if line is empty then just increase line number and continue
		{
			if(!error)
				fout1<<"\n";
			num++;
			continue;
		}
		if(token=="" && temp=="")										// if no mnemonic in the line then instruction memory pointer is not incremented
		{
			if(!error)
				fout1<<decimaltohex(to_string(loc))<<"\t"<<"  "<<label<<":"<<"\n";
			num++;
			continue;
		}
		code=opcode[token];
		if(noop.count(token)==0)										// checking whether the instruction require an operand or not
		{
			if(temp=="")											// if required but no operand exists then print expected operand
			{
				fout3<<"ERROR: operand expected on line "<<num<<"\n";
				error=true;
			}
			else if((temp[0]>='0' && temp[0]<='9') || temp[0]=='-' || temp[0]=='+')			// if operand is value
			{
				if(temp.size()>=2 && temp[0]=='0' && temp[1]=='x')
				{
					operand=valid_hex(temp);
					if(operand=="")
					{
						fout3<<"ERROR: Invalid hexadecimal number starting with 0x on line "<<num<<"\n";
						error=true;
					}
					else
						code=operand+code;
				}
				else if(temp[0]=='0' && temp.length()>1)
				{
					operand=octaltohex(temp);
					if(operand=="")
					{
						fout3<<"ERROR: Invalid Octal number starting with 0 on line "<<num<<"\n";
						error=true;
					}
					else
						code=operand+code;
				}
				else
				{
					operand=decimaltohex(temp);
					if(operand=="")
					{
						fout3<<"ERROR: A non decimal value present on line "<<num<<"\n";
						error=true;
					}
					else
						code=operand+code;
				}
			}
			else												// if operand is label
			{
				if(labels.count(temp))
				{
					if(offset.count(token))							// checking whether instruction has offset operand or exact value 
						operand=decimaltohex(to_string(labels[temp]-loc-1));			// calculating offset address if instruction requires
					else
						operand=decimaltohex(to_string(labels[temp]));
					code=operand+code;								// 32 bits machine code in hexadecimal
					used_label.insert(temp);
				}
				else											// if it's a label but label doesn't exist
				{
					fout3<<"ERROR: A non existent label was found on line "<<num<<"\n";
					error=true;
				}
			}
		}
		else													// if instruction doesn't require operand
		{
			if(temp.length())										// if operand exists but not required print error
			{
				fout3<<"ERROR: Unexpected operand present on line "<<num<<"\n";
				error=true;
			}
			code="00000000"+opcode[token];								// appending operand as 0 in no operand case
		}
		if(!error)												// if error doesn.t exist then write on listing file
		{
			if(code[9]=='*')
				code=code.substr(0,8);
			else
				code=code.substr(2,8);
			if(label=="")
				fout1<<decimaltohex(to_string(loc))<<" "<<code<<" "<<token<<" "<<temp<<"\n";
			else
				fout1<<decimaltohex(to_string(loc))<<" "<<code<<" "<<label<<": "<<token<<" "<<temp<<"\n";
			unsigned int bincode = stol(code,0,16);							// equivalent 32 unsigned int bincode of machine code
			machine.push_back(bincode);									// storing machine code integer equivalent for writing in binary file 
		}
		loc++;													// increment of instruction memory pointer
		num++;													// increment of line number in code
	}	
	for (auto it=labels.begin(); it!=labels.end(); it++)								// printing Warnings for unused labels to avoid spelling mistake by programmer
	{
		if(used_label.count(it->first)==0)
		{
			cout<<"WARNING: unused label with name "<<it->first<<":"<<endl;
			fout3<<"WARNING: unused label with name "<<it->first<<":"<<endl;
		}
	}
	fout1.close();
	fout3.close();
	if(!error)													// if no error then write in binary file
	{
		fout2.open(out2,ios::binary);
		for (int i=0; i<machine.size(); i++)
		{
			unsigned int bincode = machine[i];
			fout2.write((char*)&bincode, 4);
		}
		fout2.close();
	}
}			
