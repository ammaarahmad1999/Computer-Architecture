#include <stdio.h>
int main()
{
	printf("Please follow the rules of the games provided below\n");
	printf("In each step only 2^x balls can be taken away where 0<=x<=log(No. of balls left)\n");
	printf("Player who cannot take the ball at any step has lost the game\n");
	printf("Press any key to continue: ");
	char c;
	scanf("%c", &c);
	while(1)
	{
	printf("Enter the number of balls to start with: ");
	int num;
	scanf("%d",&num);
	while(num!=0)
	{
		if(num & num-1 == 0)
		{
			printf("Computer Won\n");
			break;
		}
		if(num % 3 == 0)
			num--;
		else
			num-=num%3;
		while (1)
		{
			printf("No of balls left: %d\n",num);
			printf("Pick the balls: ");
			int t;
			scanf("%d",&t);
			if((t & t-1) == 0 && (t<=num))
			{
				num=num-t;
				break;
			}
			else
				printf("Wrong Input, Please try Again:\n");
		}
		if(num==0)
		{
			printf("You won\n");
			break;
		}
	}
	printf("Do you want to play again: Y for Yes, N for No: ");
	scanf("%c",&c);
	if(c!='Y')	
		break;
	}
}
