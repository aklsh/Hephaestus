#include <stdio.h>

int red(int);

int main()
{
	int i = 3;
	while(i > 1)
	{
		i = red(i);
	}
	if(i != 1)
	{
		return 1;
	}
	else
	{
		return 314;
	}
	return 0;
}

int red(int i)
{
	 return i-1;
}

