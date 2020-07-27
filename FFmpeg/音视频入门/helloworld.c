#include <stdio.h>
#include <stdlib.h>

struct st{
	int a;
	float f;
};

enum em {
	red_color=5,
	green_color,
	black_color
};

int func(int a){
	printf("a=%d\n",a);
	return 0;
}

void createfile(char* filename){
	//open/create file
	FILE* file = fopen(filename,"w");
	//
	if(!file){
		printf("create file failt.\n");
		return;
	}
	
	//第二个参数是指每一项的大小，第三个参数是表示有多少项
	size_t len = fwrite("aaaa",1,5,file);
	if (len != 5) {
		printf("failt to write file,(%zu)\n",len);
		fclose(file);
		return;
	}

	printf("success");	
	//关闭
	fclose(file);
}

void read_data(char* filename) {
	FILE* file = fopen(filename,"r");
	if (!file) {
		printf("failed to read file (%s)\n",filename);
		fclose(file);
		return;
	}
	char buffer[1024] = {0,};
	size_t len = fread(buffer, 1, 3, file);
	if(len <= 0){
		printf("faile read file\n");
		return;
	}
	printf("read_data:%s\n",buffer);
	return;
}

int main(int argc, char* argv[]){
	int a = 10;
	float b = 12.5;
	char c = 'a';
	
	int d = 10;
	int e = d % 6;
	int f = d / 6;

	printf("a+b=%f, a*b=%f,c=%c, e=%d, f=%d \n",a+b, a*b, c+5, e, f);

	int arr[10] = {4,5,6,7};
	arr[0] = 1;
	arr[1] = 3;
	printf("%d,%d\n",arr[0],arr[1]);
	struct st ss;
	ss.a = 12345;
	ss.f = 4.567;
	printf("struct:%d,%f\n",ss.a,ss.f);

	enum em ee;
	ee = black_color;
	printf("enum:%d\n", ee);
	
	char* p = (char *)malloc(10);
	*p = 'a';
	*(p+1) = 'b';
	printf("p:%s\n",p);
	free(p);
	*p='d';
	printf("p:%s\n",p);

	func(2);
	int (*fp)(int);
	fp = func;
	fp(3);

	char* filePath = "/Users/fan/Downloads/fcf1.txt";
	createfile(filePath);
	read_data(filePath);
	return 0;
}

