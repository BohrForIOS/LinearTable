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


void unionList(SqList *La, SqList *Lb);

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
 线性表的单链表存储结构
 */
typedef struct Node {
    ElemType data;
    struct Node *next;
}Node;
typedef struct Node *LinkList;//定义LinkList

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

//初始化条件:顺序线性表L已存在,1<= i<=ListLength(L)
//操作结果:在L中第i个位置之前插入新的数据元素e,L的长度加1

Status LinkListInsert(LinkList *L, int i, ElemType e) {
    int j;
    LinkList p, s;
    p = *L;
    
    
    return OK;
}
@end
