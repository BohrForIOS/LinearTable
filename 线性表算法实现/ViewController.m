//
//  ViewController.m
//  线性表算法实现
//
//  Created by 王二 on 17/6/19.
//  Copyright © 2017年 mbs008. All rights reserved.
//

#import "ViewController.h"
#include <math.h>

#define MAXSIZE  100
typedef int ElemType;
/**
 定义一个顺序表
 */
typedef struct{
    ElemType data[MAXSIZE];
    int length;
}SqList;


#define OK  1
#define ERROR   0
#define TRUE    1
#define FALSE   0
typedef int Status;


/**
 线性表的单链表存储结构
 */
typedef struct Node {
    ElemType data;
    struct Node *next;
}Node, *LinkList;// LinkList为结构体指针变量

// --------线性表的静态链表-----------
typedef struct {
    ElemType data;
    int cur;// 游标域（或者说指针域）
}Component, SLinkList[MAXSIZE];// SLinkList为结构体数组，包含MAXSIZE个结构体元素

typedef int NUM[10];

/**双向循环链表存储结构**/
typedef struct DuLNode{
    ElemType data;
    struct DuLNode *prior,*next;
}DuLNode,*DuLinkList;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)btnTouch:(UIButton *)sender {
    SqList La = {.data = {1, 3, 5, 7, 9, 11},
        .length = 6};
    SqList Lb = {.data = {2, 4, 6, 8, 10, 12},
        .length = 6};
    
    // 1.获取La中第4位数的元素
    ElemType e;
    GetElem(La, 4, &e);
    printf("e = %d\n", e);
    
    // 2.元素7是否在La中存在,以及存在的位置
    ElemType a = 7;
    int location;
    Status isExist = IsExistInList(La, a, &location);
    printf("isExist = %d,位置location = %d\n", isExist, location);
    
    // 3.在顺序表中插入一个元素
    ElemType b = 20;
    int location2 = 5;
    Status insertSuccess = ListInsert(&La, location2, b);
    printf("insertSuccess = %d,  ", insertSuccess);
    printfStruct(&La);
    
    // 4.在顺序表中删除一个元素
    Status deleteSuccess = ListDelete(&La, location2, &b);
    printf("deleteSuccess = %d, 被删除元素位置是i = %d, 被删除元素为e = %d,", deleteSuccess, location2, b);
    printfStruct(&La);
    
    // 5.A U B
    unionList(&La, &Lb);
    printfStruct(&La);
}

- (IBAction)btn2Touch:(id)sender {
    // 1.创建链表
    ElemType a[] = {1, 2, 3};
    ElemType b[] = {4, 5, 6};
    int lengthA = sizeof(a)/sizeof(a[0]);
    int lengthB = sizeof(b)/sizeof(b[0]);
    
    LinkList LA = initLinkList();
    printf("头插法创建链表:\n");
    HeaderCreateLinkList(LA, a, lengthA);
    printfLinkList(LA);
    
    LinkList LB = initLinkList();
    printf("尾插法创建链表:\n");
    TailCreateLinkList(LB, b, lengthB);
    printfLinkList(LB);

     //2.获取链表元素
    ElemType e;
    GetLinkListElem(LA, 2, &e);
    printf("获取链表元素e = %d\n", e);
    
    // 3.插入元素
    LinkListInsert(LB, 2, e);
    printf("插入元素e = %d\n", e);
    printf("插入后LB:");
    printfLinkList(LB);
    
    // 4.删除元素
    
    // 5.清除链表

    // 6.合并链表
    TailCreateLinkList(LA, a, lengthA);
    printfLinkList(LA);
    

    TailCreateLinkList(LB, b, lengthB);
    printfLinkList(LB);
    
    LinkList LC = MergeLinkList(LA, LB);
    printfLinkList(LC);
}



#pragma mark - 顺序表的操作

/**
 获取元素操作

 @param L 顺序表
 @param i 线性表中第几个元素
 @param e 元素地址，获取的元素存放在这个地址里

 @return 获取元素是否成功
 */
Status GetElem(SqList L, int i, ElemType *e) {
    if ((L.length == 0 || i < 1 || i > L.length)) {
        return ERROR;
    }
    
    *e = L.data[i-1];
    return OK;
}


/**
 元素e是否在线性表中存在

 @param L 线性表
 @param e 元素
 @param i 元素所在位置的地址
 @return 元素在表中存在
 */
Status IsExistInList(SqList L, ElemType e, int *i) {
    int k ;
    
    if (L.length == 0) {// 空表
        return ERROR;
    }
    
    for (k = 0; k < L.length; k++) {
        if (L.data[k] == e) {
            *i = k;
            return OK;
        }
    }
    
    return OK;
}

//Status LocateElem(SqList L, )
/*
 插入操作
 
 插入算法的思路:
 
 如果插入的位置不合理,抛出异常
 如果线性表长度大于等于数组长度,则抛出异常或动态增加容量
 从最后一个元素开始向前遍历到第i个位置,分别将他们都向后移动一个位置
 将要插入元素填入位置i处
 表长 + 1

 */

/**
 插入操作

 @param L 线性表地址
 @param i 要插入的位置
 @param e 要插入的元素

 @return 是否插入成功
 */
Status ListInsert (SqList *L, int i, ElemType e) {
    //初始化条件:顺序线性表L已存在,1<= i <= ListLengt(L)
    int k;
    
    if (L->length == MAXSIZE) {//顺序线性表已满
        return ERROR;
    }
    
    if (i < 0 || i > L->length + 1) return ERROR;//当i不在范围内
    
    if (i == 0) {// 头部插入
        L->data[i] = e;
        
        for (k = L->length - 1; k > 0; k--) {//将要插入位置后数据元素向后移动一位
            L->data[k] = L->data[k-1];
        }
        
        
        L->length++;
        L->data[L->length] = L->data[L->length - 1];
        
        return OK;
    }
    
    if (i == L->length + 1) {// 在末尾插入
        L->length++;
        L->data[L->length] = e;
         return OK;
    }
    
    // 中部插入
    L->length++;
    for (k = L->length - 1; k > i; k--) {//将要插入位置后数据元素向后移动一位
        L->data[k] = L->data[k - 1];
    }

    L->data[i] = e;
    
    return OK;
}

/*
 删除操作
 
 删除操作思路
 
 如果删除位置不合理,抛出异常
 取出删除元素
 从删除元素位置开始遍历到最后一个元素位置,分别将它们都向前移动一个位置
 表长 -1
 */
Status ListDelete (SqList *L, int i, ElemType *e) {
    //初始化条件:顺序线性表已存在,1 <= i<= ListLength(L)
    //操作结果:删除L的第i个数据元素,并用e返回其值,L的长度-1
    int k;
    
    if (L->length == 0) { //线性表为空
        return ERROR;
    }
    
    if (i < 1 || i > L->length) {//删除位置不正确
        return ERROR;
    }
    
    // 给e赋值被删除的元素
    *e = L->data[i-1];
    
    if (i < L->length) {//如果删除的不是最后位置
        //将删除位置后元素前移
        for (k = i; k < L->length; k++) {
            L->data[k-1] = L->data[k];
        }
    }
    
    L->length--;
    
    return OK;
}

/*
 插入和删除的时间复杂度
 
 最好情况:插入和删除的都在最后一个元素,此时时间复杂度为 O(1)
 最坏情况:插入和删除的都是第一个元素,移动所有的元素,时间复杂度为O(n)
 平均情况:次数为(n- 1)/ 2,时间复杂度还是O(n)
 */
// 实现两个线性集合A和B的并集操作,即A = A U B,就是把集合B中但并不存在A中的数据元素插入到A中即可.
/*
 操作:
 1.循环集合B中的每个元素
 2.判断当前元素是否存在A中
 3.若不存在,则插入到A中即可
 */
void unionList(SqList *La, SqList *Lb) {
    ElemType e;
    
    for (int i = 0; i < Lb->length; i++) {
        e = Lb->data[i];//取Lb中第i个数据元素赋给e
        int j;
        printf("位置i = %d, 元素e = %d\n", i, e);
        if (IsExistInList(*La, e, &j)) {//La中不存在和e相同的数据元素
            printf("要插入的元素e = %d\n", e);
            ListInsert(La, La->length, e);// 插入
            printf("插入后La:\n");
            printfStruct(La);
        }
    }
}

/**
 打印顺序表

 @param L 顺序表指针
 */
void printfStruct(SqList *L) {
    for (int i = 0; i < L->length; i++) {
        if (i == 0) {
            printf("L->data = {");
        }
        
        if (i > 0) {
            printf(",");
        }
        
        
        printf("%d", L->data[i]);
        
        if (i == L->length - 1) {
            printf("},");
        }
    }
    
    printf("L->length = %d\n", L->length);
}

#pragma mark - 链表


/**
 初始化链表

 @return 带头指针，头结点的链表
 */
LinkList initLinkList() {
    LinkList L;
    
    L = (LinkList)malloc(sizeof(Node));
    
    if (L == NULL) {
        printf("申请空间失败");
        exit(-1);
    }

    L->next = NULL;// 设置头指针的指针域为NULL
    
    return L;
}

/*
 单链表的创建
 
 思路:始终让新结点在第一位置,称为头插法
 
 1.声明一结点p和计数器变量i
 2.初始化一空链表L
 3.让L的头结点的指针指向NULL ,即建立一个带头结点的单链表
 4.循环
 1)生成一新结点赋值给p
 2)随机生成一数字赋值给p的数据域p -> data;
 3)将p插入到头结点与前一新结点之间
 */
void HeaderCreateLinkList(LinkList L, ElemType a[], int n) {
    Node *p;

    for (int i = 0; i < n; i++) {
        p = (LinkList)malloc(sizeof(Node));//生成新的结点
        
        if (p == NULL) {
            printf("初始化失败\n");
            exit(-1);
        }
        
        p->data = a[i];
        p->next = L->next;
        L->next = p;//始终插入到表头
    }
}

// 我们也可以把每次新结点都插在终端结点的后面,我们称为尾插法
void TailCreateLinkList(LinkList L, ElemType a[], int n) {
    LinkList p, r;
    
    r = L; /*r始终指向终端结点,开始时指向头结点*/
    
    for (int i = 0; i < n; i++) {
        p = (Node *)malloc(sizeof(Node));//生成新的结点
        
        if (p == NULL) {
            printf("申请空间失败");
            exit(0);
        }
        
        p->data = a[i];
        r->next = p;//将表尾终端结点的指针指向新结点
        r = p;//将当前的新结点定义为表尾终端指针
    }
    
    r->next = NULL;//表示当前链表结束
}

/*
 单链表的整表删除
 
 单链表的整表删除思路:
 
 1.声明一结点p 和q
 2.将第一结点赋值为p
 3.循环:
 1)将下一结点赋值给q
 2)释放p
 3)将q赋值给p
 */
void ClearLinkList (LinkList L) {
    LinkList p,q;
    p = L->next;//p指向第一个结点
    while (p) {// 逐步清空
        q = p->next;
        free(p);
        p = q;
    }
    
    L->next = NULL;//头结点指针域为空
}

/**
 判断单链表是否为空

 @param L 单链表指针

 @return y/n
 */
Status LinkListIsEmpty(LinkList L) {
    return (L->next == NULL);
}

/**
 链表的长度

 @param L 链表指针

 @return 链表长度
 */
int LinkListLength(LinkList L) {
    int i = 0;
    LinkList p = L;
    
    while (p->next) {
        i++;
        p = p->next;
    }
    
    return i;
}

/**
 获取链表某个位置的元素

 @param L 链表
 @param i 链表里某个位置
 @param e 链表里某个位置对应的元素

 @return 是否获取成功
 */
Status GetLinkListElem(LinkList L, int i, ElemType *e) {
    int j;
    LinkList p;////声明一结点p
    p = L->next;//让p指向链表L的第一个结点
    j = 1;//j为计数器
    while (p && j < i) {//p不为空或者计数器j还没有等于i时,循环继续
        p = p->next;//让p指向下一个结点
        ++j;
    }
    
    if (!p || j > i) {
        return ERROR;//第i个元素不存在
    }
    
    *e = p->data;//取第i个元素的数据
    return OK;// 单链表的最坏时间复杂度是O(n)
}

/*
 单链表第i个数据插入节点的算法思想
 
 1.声明一结点p指向链表第一个结点,初始化j 从1开始
 2.当j < i时,就遍历链表,让p的指针向后移动,不断指向下一结点,j累加1;
 3.若到链表末尾p为空,说明第i个元素不存在
 4.否则查找成功,在系统中生成一个空结点s;
 5.将数据元素e赋值给s->data
 6.单链表的插入标准语句s->next = p->next,p->next = s;
 7.返回成功
 */

//初始化条件:单链表L已存在,1<= i<=ListLength(L)

Status LinkListInsert(LinkList L, int i, ElemType e) {
    int j;
    LinkList p, s;
    p = L;
    j = 1;
    
    // 先寻找
    while (p && j < i) {
        p = p->next;
        j++;
    }
    
    if (!p || j > i) {
        return ERROR;
    }
    
    // 再插入
    s = (Node *) malloc(sizeof(Node));//生成新的结点
    s->data = e;
    s->next = p->next;//将p的后继结点赋值给s的后继
    
    p->next = s;//将s赋值给p的后继
    
    return OK;
}

/*
 单链表第i个数据删除结点的算法思路
 
 1.声明一结点p指向链表第一个结点,初始化j从1开始
 2.当j < i时,就遍历链表,让p的指针向后移动,不断指向下一个结点,j 累加1
 3.若到链表末尾p为空,则说明第i个元素不存在
 4.否则查找成功,将欲删除结点p->next赋值给q
 5.单链表的删除标准语句 p->next = q -> next
 6.将q结点中的数据赋值给e,作为返回
 7.释放q结点
 8.返回成功
 */
Status DeleteLinkList(LinkList L, int i, ElemType *e) {
    LinkList p, q;
    int j = 1;
    p = L;
    
    while (p->next && j < i) {//遍历寻找第i个元素
        p = p->next;
        j++;
    }
    
    if (!(p->next) || j > i) {/*第i个结点不存在*/
        return ERROR;
    }
    
    q = p->next;// 第i个结点
    p->next = q->next;//将q的后继赋值给p的后继
    *e = q->data;
    
    free(q);// 释放q
    
    return OK;
}

LinkList MergeLinkList(LinkList La, LinkList Lb) {
   // 已知单链线性表La和Lb的元素按值非递减排列
    // 归并La和Lb得到新的单链表Lc，Lc的元素也按值非递减排列
    LinkList pa = La->next;// La第一个节点
    LinkList pb = Lb->next;// Lb第一个节点
    LinkList Lc = initLinkList();// 初始化pc
    Lc = La;
    LinkList pc = Lc;//用La的头节点作为Lc的头结点；
    
    while (pa && pb) {
        if (pa->data <= pb->data) {
            pc->next = pa;//
            pc = pa;
            pa = pa->next;// pa往后移动一位
        }
        else {
            pc->next = pb;
            pc = pb;
            pb = pb->next;
        }
    }
    
    pc->next = pa ? pa : pb;// 插入剩余片段
//    free(Lb);// 释放Lb的头结点
    return Lc;
}

/**
 打印链表

 @param L 链表
 */
void printfLinkList(LinkList L) {
    LinkList p;
    p = L;
    
    int i = 0;
    
    while(p) {
        if (i == 0) {
            printf("头结点L->data = %d, L->next = %p\n", p->data, p->next);
        }
        else {
            printf("节点%d: p->data = %d, p->next = %p\n", i, p->data, p->next);
        }
        
        p = p->next;
        i++;
    }
}

#pragma mark - 顺序存储和链接存储比较
/*
 顺序存储表示是将数据元素存放于一个连续的存储空间中，实现顺序存取或(按下标)直接存取。它的存储效率高，存取速度快。但它的空间大小一经定义，在程序整个运行期间不会发生改变，因此，不易扩充。同时，由于在插入或删除时，为保持原有次序(没有规定元素进栈顺序)，平均需要移动一半(或近一半)元素，修改效率不高。
 
 链接存储表示的存储空间一般在程序的运行过程中动态分配和释放，且只要存储器中还有空间，就不会产生存储溢出的问题。同时在插入和删除时不需要保持数据元素原来的物理顺序，只需要保持原来的逻辑顺序，因此不必移动数据，只需修改它们的链接指针，修改效率较高。但存取表中的数据元素时，只能循链顺序访问，因此存取效率不高。
 
 利用单链表可以解决顺序表需要大量的连续存储空间的缺点，但是单链表附加指针域，也带来了浪费存储空间的缺点。由于单链表的元素是离散地分布在存储空间中，所以单链表是非随机存取的存储结构。
 
 头结点和头指针的区分：不管带不带头结点，头指针始终指向链表的第一个结点，而头结点是带头结点链表中的第一个结点，结点内通常不存储信息。
 
 引入头结点后，可以带来两个优点：
 
 由于开始结点的位置被存放在头结点的指针域中，所以在链表的第一个位置上的操作和在表的其他位置上的操作一致，无须进行特殊处理。
 无论链表是否为空，其头指针是指向头结点的非空指针（空表中头结点的指针域为空），因此空表和非空表的处理也就统一了。
 */

#pragma mark - 线性表的静态链表

#define N  9

/**
 初始化成空闲静态链表

 @param S 静态链表
 */
void Init_SL(SLinkList S) {
    int i;
    
    for (i = 0; i < N - 1; i++) {
        S[i].cur = i + 1;// 给指针域赋值
    }
    
    S[N-1].cur = 0;// 最后一个指针域指向0;0表示空指针
}

/**
 申请分配一个空闲节点  注意：这里每次申请空闲节点都是把空闲链表的第一个节点（非头节点）返回，同理在释放空闲节点到空闲链表的的时候也是把空闲节点加到空闲链表头指针的后面第一个的位置

 @param S 静态链表

 @return 申请到的空闲结点的数组下标
 */
int Malloc_SL(SLinkList S) {
    // 从备用链表中取出一个结点（类似于从备用链表中移除第一个备用结点）
    int i = S[0].cur;// 总是取头结点之后的第一个空闲结点做分配，同时空闲链表非空，头结点做调整
    
    if (i) {
        S[0].cur = S[i].cur;//空闲链表头结点调整指针域
    }
    
    return i;//返回申请到的空闲节点的数组下标
}

/**
 释放一个空闲节点到空闲链表  //将k节点回收

 @param S 静态链表
 @param k 结点k
 */
void Free_SL(SLinkList S, int k) {
    // 备用链表的头结点的游标S[0].cur
    // 结点k的游标移到备用链表的头结点的游标
    // 头结点的游标S[0].cur移动到结点k
    // 头结点也成为备用链表中的一员，且是以头插法的形式插入到备用链表中
    S[k].cur = S[0].cur;//总是将回收的节点放在头结点之后
    S[0].cur = k;
}

/**
 在静态单链线性表中查找第一个值为e的元素

 @param S 静态单链表
 @param e 元素

 @return e在单链表中出现的第一个位置，若找到，返回它在L中的位序，否则返回0
 */
int LocateElem_SL(SLinkList S, ElemType e) {
    int i = S[0].cur;// i指示表中第一个结点
    
    while (i && S[i].data != e) {
        i = S[i].cur;// 在表中顺链查找
    }
    
    return i;
}


- (IBAction)btn3Touch:(id)sender {
    SLinkList SL;
    int s;
    
    difference2(SL, s);
    printfSLinkListFromCurse(SL, 1);
    
}


/**
 (A-B)U(B-A)  假设由终端输入集合元素，先建立表示集合A的静态链表S，而后在输入集合B的元素的同时查找S表，若存在和B相同的元素，则从S表中删除之，否则将次元素插入S表

 @param space 静态链表
 @param s     头结点
 */
void difference(SLinkList space,int s) {
    // 依次输入集合A和B的元素，在一维数组space中建立表示集合（A-B）U（A+B）的静态链表，S为其头指针。
    Init_SL(space);// 初始化静态链表备用空间
    s = Malloc_SL(space);// 生成静态链表的头结点
    int r = s;// r指向静态链表的当前的最后结点
    
    // 输入m,n
    int m, n;
    scanf("%d%d", &m, &n);
    
    // 建立集合A的链表
    
    for (int j = 1; j <= m; ++j) {
        int i = Malloc_SL(space);// 分配结点
        scanf("%d", &space[i].data);// 输入A的元素值
        space[r].cur = i; r = i;// 修改尾指针
    }
    
    space[r].cur = 0;//尾结点的指针为空
    
    // 依次输入B的元素，，若不在当前表中，则插入，否则删除
    for (int j = 1; j <= n; j++) {
        int b;
        scanf("%d", &b);
        
        int p = s;
        int k = space[s].cur;  // k指向集合A中第一个结点；
        
        // 在当前表中查找
        while (k != space[r].cur && space[k].data != b) {
            p = k;
            k = space[k].cur;// 指向集合A元素中的下一个
        }
        
        if (k == space[k].cur) {// 当前表中不存在该元素，插入在r所指结点之后（r所指结点为集合A尾结点），且r的位置不变
            int i = Malloc_SL(space);
            space[i].data = b;
            space[i].cur = space[r].cur;
            space[r].cur = i;         // 此时i结点变成尾结点
        }
        else {// 该元素已经在表中，删除之
            space[p].cur = space[k].cur;
            Free_SL(space, k);
            if (r == k) {
                r = p; // 若删除的是r所指结点，则需修改尾指针
            }
        }
    }
}

/**
 (A-B)U(B-A)  假设由终端输入集合元素，先建立表示集合A的静态链表S，而后在输入集合B的元素的同时查找S表，若存在和B相同的元素，则从S表中删除之，否则将次元素插入S表
 
 @param space 静态链表
 @param s     头结点
 */
void difference2(SLinkList space,int s) {
    // 依次输入集合A和B的元素，在一维数组space中建立表示集合（A-B）U（B-A）的静态链表，S为其头指针。
    Init_SL(space);// 初始化静态链表备用空间
    s = Malloc_SL(space);// 生成静态链表的头结点  1
    int r = s;// r指向静态链表的当前的最后结点
    
    int a[] = {1,2,3};
    int b[] = {4,3};
    int lengthA = sizeof(a)/sizeof(a[0]);
    int lengthB = sizeof(b)/sizeof(b[0]);
    
    // 建立集合A的链表
    for (int j = 0; j < lengthA; ++j) {
        int i = Malloc_SL(space);// 分配结点
        space[i].data = a[j];// 给结点赋值
        space[r].cur = i; r = i;// 修改尾指针
    }
    
    space[r].cur = 0;//尾结点的指针为空
    
    // 依次取出B的元素，，若不在当前表中，则插入，否则删除
    for (int j = 0; j < lengthB; j++) {
        int bValue = b[j];
        
        int p = s;
        int k = space[s].cur;  // k指向集合A中第一个结点；
        
        // 在当前表中查找
        while (k != space[r].cur && space[k].data != bValue) {
            p = k;
            k = space[k].cur;// 指向集合A元素中的下一个
        }
        
        if (k == space[r].cur) {// 当前表中不存在该元素，插入在r所指结点之后（r所指结点为集合A尾结点），且r的位置不变
            int i = Malloc_SL(space);
            space[i].data = bValue;
            space[i].cur = space[r].cur;
            space[r].cur = i;         // 此时i结点变成尾结点
        }
        else {// 该元素已经在表中，删除之
            space[p].cur = space[k].cur;
            Free_SL(space, k);
            if (r == k) {
                r = p; // 若删除的是r所指结点，则需修改尾指针
            }
        }
    }
}


void printfSLinkListFromCurse(SLinkList S, int start) {
    int p = S[start].cur;// 开始位置的游标
    
    while (p) {
        printf("S[%d].data = %d, S[%d].cur = %d\n", p, S[p].data, p, S[p].cur);
        p = S[p].cur;
    }
    
    printf("\n");
}

#pragma mark - 双向循环链表

/**构造一个空的双向循环链表L**/

void InitList_DuL(DuLinkList L) {
    L = (DuLinkList)malloc(sizeof(DuLNode));
    
    if (L) {
        L->next = L->prior = L;
    }
}

void DestroyList_DuL(DuLinkList L) {
    DuLinkList p, q;
    p = L->next; // p指向第一个结点
    
    while(p) {
        q = p->next; // q指向p下一个结点
        free(p); // 销毁p
        p = q;// 重新复制p
    }
    
    free(L);// 销毁
}

/**L已存，将L重置为空表**/
void ClearList_DuL(DuLinkList L) {
    DuLinkList q,p;
    p = L->next;
    
    while (p != L) {
        q = p->next;
        free(p);
        p = q;
    }
    
    L->next = L->prior = L;
}


/**返回L中数据元素个数**/
int ListLength_DuL(DuLinkList L) {
    int i = 0;
    DuLinkList p;
    
    p = L->next;
    
    if (p != L) {
        i++;
        p = p->next;
    }
    
    return i;
}

/**当第i个元素存在时，其值赋给e并返回OK，否则返回ERROR**/
Status GetElem_DuL(DuLinkList L, int i, ElemType *e) {
    int j = 1;
    
    DuLinkList p;
    p = L->next;
    
    while(p != L && j < i) {
        j++;
        p = p->next;
    }
    
    if (p == L || j > i) { //第i个元素不存在
        return ERROR;
    }
    
    *e = p->data;
    
    return OK;
}

/**
 操作结果：若cur_e是L的数据元素，且不是第一个，则用pre_e返回它的前驱,
 否则操作失败，pre_e无定义
 **/
Status PriorElem_DuL(DuLinkList L, ElemType cur_e, ElemType *pre_e) {
    DuLinkList p = L->next->next;
    
    while (p != L) {
        if (p->data == cur_e) {
            *pre_e = p->prior->data;
            
            return TRUE;
        }
        
        p = p->next;
    }
    
    return false;
}


/**
 操作结果：若cur_e是L的数据元素，且不是最后一个，则用next_e返回它的后继,
 否则操作失败，next_e无定义
 **/
Status NextElem_DuL(DuLinkList L,ElemType cur_e,ElemType *next_e){
    DuLinkList p = L->next->next;
    
    while(p != L) {
        if (cur_e == p->prior->data) {
            *next_e = p->data;
            
            return true;
        }
        
        p = p->next;
    }
    
    return false;
}


@end
