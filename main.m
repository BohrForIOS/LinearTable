#include <math.h>
#include <stdio.h>

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
}Node, *LinkList;

// --------线性表的静态链表-----------
typedef struct {
    ElemType data;
    int cur;// 游标域（或者说指针域）
}component, SLinkList[MAXSIZE];// SLinkList为结构体数组，包含MAXSIZE个结构体元素

typedef int NUM[10];
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

void printfSLinkListFromCurse(SLinkList S, int start) {
    int p = S[start].cur;// 开始位置的游标
    
    while (p) {
        printf("%c", S[p].data);
        p = S[p].cur;
    }
    
    printf("\n");
}


