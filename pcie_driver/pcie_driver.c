#include <pci/pci.h>
#include <pciaccess.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctype.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <math.h>
#include<stdio.h>
#include <stdlib.h>


static struct pci_access *myaccess = NULL;
static struct pci_dev *mydev = NULL;
static struct pci_dev *dev = NULL;

static unsigned int pcieVirAddr_fd;

int InitPcieDevice(int vendor_id, int device_id)
{
	myaccess = pci_alloc();

	pci_init(myaccess);

	pci_scan_bus(myaccess);

	for (mydev = myaccess->devices; mydev; mydev = mydev->next)
	{

		pci_fill_info(mydev, PCI_FILL_IDENT | PCI_FILL_BASES | PCI_FILL_CLASS);

		if (mydev->device_id == device_id)
		{
			dev = mydev;
			printf("find device,vendor_id=%#x device_id=%#x\n", vendor_id, device_id);
			return 0;
			//break;
		}
	}

	if (dev == NULL)
	{
		printf("can't find device!!!,vendor_id=%#x device_id=%#x\n", vendor_id, device_id);
		return -1;
	}

	return 0;
}

unsigned char *PcieVirAddrMap(unsigned int phy_addr, unsigned int size)
{

	unsigned char *pcieVirtAddr = NULL;

	if ((pcieVirAddr_fd = open("/dev/mem", O_RDWR)) < 0)
	{
		printf("%s open mem fail\n", __FUNCTION__);
		return NULL;
	}
	//printf("%s %d\n",__FUNCTION__,__LINE__);
	//mmap(NULL , tStat.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, iFd, 0);
	pcieVirtAddr = (unsigned char *)mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, pcieVirAddr_fd, phy_addr);

	if (pcieVirtAddr == NULL)
	{
		printf("mmap pcieBufVirtAddr failed !!! \n");
		return NULL;
	}
	//printf("sdafds\n");
	return pcieVirtAddr;
}


float calculate_distance_norm_2(float a_0, float a_1, float b_0, float b_1)
{
	float sum = 0.0;

	sum += (a_0 - b_0) * (a_0 - b_0);
	sum += (a_1 - b_1) * (a_1 - b_1);

	return sqrt(sum);
}
void test()
{
	unsigned int traing_num = 1024;
	unsigned int dimension = 2;
	unsigned int k_num = 10;
	unsigned int iteration_times = 50;

	/*load data*/
	FILE *fp;
	fp = fopen("europediff_169300_2.txt", "r"); 
	float test_data[traing_num][2];
	for (int i = 0; i < traing_num; ++i)
	{
		fscanf(fp, "%f%f", &(test_data[i][0]), &(test_data[i][1]));
	}
	fclose(fp);

	/*software*/
	float sum[2];
	float center_init[k_num][2];
	float center[k_num][2];
	float new_center[k_num][2];
	float new_center_num[k_num];
	int belong[traing_num];
	int belong_num[traing_num];
	float belong_sum[traing_num][dimension];
	for (int i = 0; i < traing_num; ++i)
	{
		belong[i] = 0;
		belong_num[i] = 0;
		for (int j = 0; j < dimension; ++j)
			belong_sum[i][j] = 0.0;
	}
	sum[0] = 0.0;
	sum[1] = 0.0;
	for (int i = 0; i < traing_num; ++i)
	{
		sum[0] += test_data[i][0];
		sum[1] += test_data[i][1];
	}
	belong_num[0] = traing_num;
	belong_sum[0][0] = sum[0];
	belong_sum[0][1] = sum[1];

	for (int i = 0; i < k_num; ++i)
	{
		int pos = rand() % traing_num;
		center[i][0] = test_data[pos][0];
		center[i][1] = test_data[pos][1];
		center_init[i][0] = center[pos][0];
		center_init[i][1] = center[pos][1];
	}

	for (int i = 0; i < iteration_times; ++i)
	{

		for (int j = 0; j < traing_num; ++j)
		{
			float distance = __FLT_MAX__;
			int belong_pos = 0;
			for (int k = 0; k < k_num; ++k)
			{
				float temp = calculate_distance_norm_2(test_data[j][0], test_data[j][1], center[k][0], center[k][1]);
				if (temp < distance)
				{
					distance = temp;
					belong_pos = k;
				}
			}
			if (belong[j] != belong_pos)
			{
				for (int k = 0; k < dimension; ++k)
				{
					belong_sum[belong[j]][k] -= test_data[j][k];
					belong_sum[belong_pos][k] += test_data[j][k];
				}
				belong_num[belong[j]] -= 1;
				belong_num[belong_pos] += 1;
				belong[j] = belong_pos;
			}
			new_center[belong_pos][0] += test_data[j][0];
			new_center[belong_pos][1] += test_data[j][1];
			new_center_num[belong_pos] += 1.0;
		}

		for (int j = 0; j < k_num; ++j)
		{
			if (belong_num[j] != 0)
			{
				center[j][0] = belong_sum[j][0] / belong_num[j];
				center[j][1] = belong_sum[j][1] / belong_num[j];
			}
		}
	}
	printf("software result:\n");
	for (int i = 0; i < k_num; ++i)
	{
		printf("(%f , %f)\n", center[i][0], center[i][1]);
	}
	printf("\n\n\n\n\n\n\n");

	/*hardware*/
	InitPcieDevice(0x10ee, 0x7014);
	int barIndex = 0;
	unsigned int addr = pci_read_long(dev, ((barIndex + 1) << 4));
	unsigned char *pcieVirtAddr = PcieVirAddrMap(addr, 0x7ffffff); //2^27byte = 128M
	float *pcieVirtAddr_float = (float *)pcieVirtAddr;
	unsigned int *pcieVirtAddr_unsigned_int = (unsigned int *)pcieVirtAddr;

	unsigned int belong_start_addr = 16;
	unsigned int data_start_addr = 16 + traing_num * 8;		  
	unsigned int center_start_addr = 16 + traing_num * 8 * 2; 
	unsigned int data_step = 8;

	pcieVirtAddr_unsigned_int[0] = traing_num;
	pcieVirtAddr_unsigned_int[1] = dimension;
	pcieVirtAddr_unsigned_int[2] = k_num;
	pcieVirtAddr_unsigned_int[3] = iteration_times;
	pcieVirtAddr_unsigned_int[4] = belong_start_addr;
	pcieVirtAddr_unsigned_int[5] = data_start_addr;
	pcieVirtAddr_unsigned_int[6] = center_start_addr;
	pcieVirtAddr_unsigned_int[7] = data_step;

	pcieVirtAddr_float[16] = sum[0];
	pcieVirtAddr_float[17] = sum[1];
	for (int i = 0; i < traing_num; ++i)
		pcieVirtAddr_unsigned_int[(belong_start_addr + data_step * i) * 2] = 0; 
	for (int i = 0; i < traing_num; ++i)
	{
		pcieVirtAddr_float[(data_start_addr + data_step * i) * 2 + 0] = test_data[i][0];
		pcieVirtAddr_float[(data_start_addr + data_step * i) * 2 + 1] = test_data[i][1];
	}
	for (int i = 0; i < k_num; ++i)
	{
		pcieVirtAddr_float[(center_start_addr + data_step * i) * 2 + 0] = center_init[i][0];
		pcieVirtAddr_float[(center_start_addr + data_step * i) * 2 + 1] = center_init[i][1];
	}
	printf("%d\n", pcieVirtAddr_unsigned_int[0]); //start

	printf("hardware result:\n");
	for (int i = 0; i < k_num; ++i)
	{
		printf("%d:,(%f , %f)\n",(center_start_addr + data_step * i) * 2 + 0,pcieVirtAddr_float[(center_start_addr + data_step * i) * 2 + 0], pcieVirtAddr_float[(center_start_addr + data_step * i) * 2 + 1]);
	}
}

int main(void)
{
	test();

	return 0;
}