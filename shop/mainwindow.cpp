
#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QMessageBox>
#include <QSpinBox>
#include <QDebug>
#include <QFile>
#include <QFileDialog>
#include<QPainter>
#include <QTableView>
#include <QListView>
#include <QTreeWidget>
#include <QStandardItemModel>
#include <QStandardItem>
QString water;
int count=1;
double money=0;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->incontrol,&QMenu::triggered,this,&MainWindow::in_);
    connect(ui->stock,&QAction::triggered,this,&MainWindow::stock_);
    connect(ui->incomecontrol,&QMenu::triggered,this,&MainWindow::income_);
    connect(ui->salecontrol,&QMenu::triggered,this,&MainWindow::sale_);
    connect(ui->change,&QAction::triggered,this,&MainWindow::change_);
    inittable();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::inittable()
{
    table_view = ui->tableView;
    item_model = new QStandardItemModel(8,4);  // 4行4列
    table_view->setModel(item_model);//两者关联
    QStringList column, row;//行列表头
    column << "商品名称" << "条形码" << "商品数量" << "商品进价" << "商品售价"  << "供应商" ;
    row << "1" << "2" << "3" << "4";
    item_model->setHorizontalHeaderLabels(column);                // 设置水平表头标签
    item_model->setVerticalHeaderLabels(row);
    table_view->setEditTriggers(QTreeView::NoEditTriggers);


    table_view_2 = ui->tableView_2;
    item_model_2 = new QStandardItemModel(8,4);  // 4行4列
    table_view_2->setModel(item_model_2);//两者关联
    QStringList column2, row2;//行列表头
    column2 << "商品名称" << "条形码" << "购买数量"  << "商品价格"  << "供应商" << "总计";
    row2 << "1" << "2" << "3" << "4";
    item_model_2->setHorizontalHeaderLabels(column2);                // 设置水平表头标签
    item_model_2->setVerticalHeaderLabels(row2);
    table_view_2->setEditTriggers(QTreeView::NoEditTriggers);
}
void MainWindow::in_(){
    ui->stackedWidget->setCurrentWidget(ui->page_2);
}
void MainWindow::stock_(){
    ui->stackedWidget->setCurrentWidget(ui->page);
}
void MainWindow::income_(){
    ui->stackedWidget->setCurrentWidget(ui->page_4);
}
void MainWindow::sale_(){
    ui->stackedWidget->setCurrentWidget(ui->page_3);
}
void MainWindow::change_(){
    ui->stackedWidget->setCurrentWidget(ui->page_5);
}
void MainWindow::on_input_clicked()
{
    if(ui->goodname->text().isEmpty())
        QMessageBox::information(this,"入库提示","商品名称不能为空");
    else if(ui->barcode->text().isEmpty())
        QMessageBox::information(this,"入库提示","条形码不能为空");
    else if(ui->amount->text().isEmpty())
        QMessageBox::information(this,"入库提示","商品数量不能为空");
    else if(ui->amount->text()=="0")
        QMessageBox::information(this,"入库提示","商品数量不能为0");
    else if(ui->inPrice->text().isEmpty())
        QMessageBox::information(this,"入库提示","进价不能为空");
    else if(ui->outPrice->text().isEmpty())
        QMessageBox::information(this,"入库提示","售价名称不能为空");
    else if(ui->sup->text().isEmpty())
        QMessageBox::information(this,"入库提示","供货商不能为空");
    else{
        Good * f =new Good(ui->goodname->text(),ui->barcode->text(),ui->amount->text().toInt(),ui->inPrice->text().toDouble(),ui->outPrice->text().toDouble(),ui->sup->text());
    if(shop.find(ui->goodname->text())!=shop.end())
    {
        int pe =shop[ui->goodname->text()]->getnumber();
       shop[ui->goodname->text()]->setnumber(pe+ui->amount->text().toInt());
       QMessageBox::information(this,"入库提示",ui->goodname->text()+"已成功新增");
       QString str;
       str=QString("第%1次操作 ，进货%2 ，数量%3 ，付款%4元").arg(count).arg(ui->goodname->text()).arg(ui->amount->text().toInt()).arg(ui->inPrice->text().toDouble()*ui->amount->text().toInt());
       water+=str+"\n";
       ui->list_2->setText(water);
       count++;
       //money-=(ui->inPrice->text().toDouble()*ui->amount->text().toInt());
    }
    else
    {
        shop[ui->goodname->text()] = f;
        QMessageBox::information(this,"入库提示",ui->goodname->text()+"已成功入库");
        QString str;
        str=QString("第%1次操作 ，进货%2 ，数量%3 ，付款%4元").arg(count).arg(ui->goodname->text()).arg(ui->amount->text().toInt()).arg(ui->inPrice->text().toDouble()*ui->amount->text().toInt());
        water+=str+"\n";
        ui->list_2->setText(water);
        count++;
        //money-=(ui->inPrice->text().toDouble()*ui->amount->text().toInt());
    }

    ui->goodname->clear();
    ui->barcode->clear();
    ui->amount->clear();
    ui->inPrice->clear();
    ui->outPrice->clear();
    ui->sup->clear();
    }
}



void MainWindow::on_findbtn_clicked()
{
    QString list;
    int s=0;
    QMap<QString ,Good*>::Iterator it;
    for(it=shop.begin();it!=shop.end();it++)
        {
            QString str ;
            if(it.value()->getnumber()==0)
            {

                str =QString("%1已经缺货，请及时补货").arg(it.value()->getname());
                str=str+"\n";
                s++;
            }
            list=list+str;
        }
    if(s==0) QMessageBox::information(this,"提示","库存中未存在缺货商品");
    else QMessageBox::information(this,"提示","以为你展示全部缺货商品");

    ui->textEdit->setText(list);
}


void MainWindow::on_pushButton_clicked()
{
    item_model->clear();
    item_model = new QStandardItemModel(8,4);  // 4行4列
    table_view->setModel(item_model);//两者关联
    QStringList column, row;//行列表头
    column << "商品名称" << "条形码" << "商品数量" << "商品进价" << "商品售价"  << "供应商" ;
    row << "1" << "2" << "3" << "4";
    item_model->setHorizontalHeaderLabels(column);                // 设置水平表头标签
    item_model->setVerticalHeaderLabels(row);
    table_view->setEditTriggers(QTreeView::NoEditTriggers);

    QMap<QString ,Good*>::Iterator itt;
    int i=0;
    for(itt=shop.begin();itt!=shop.end();itt++)
        {
            item_model->setItem(i,0,new QStandardItem(QString("%1").arg(itt.value()->getname())));
            item_model->setItem(i,1,new QStandardItem(QString("%1").arg(itt.value()->getcode())));
            item_model->setItem(i,2,new QStandardItem(QString("%1").arg(itt.value()->getnumber())));
            item_model->setItem(i,3,new QStandardItem(QString("%1").arg(itt.value()->getinprice())));
            item_model->setItem(i,4,new QStandardItem(QString("%1").arg(itt.value()->getoutprice())));
            item_model->setItem(i,5,new QStandardItem(QString("%1").arg(itt.value()->getsupplier())));
            i++;
        }
    QMessageBox::information(this,"提示","已为你显示全部库存信息");
    QString list;
    QMap<QString ,Good*>::Iterator it;
    for(it=shop.begin();it!=shop.end();it++)
        {
            QString str;
            str=QString("商品名称：%1  条形码：%2  数量：%3  进价：%4  售价：%5  供应商：%6").arg(it.value()->getname()).arg(it.value()->getcode()).arg(it.value()->getnumber()).arg(it.value()->getinprice()).arg(it.value()->getoutprice()).arg(it.value()->getsupplier());
            str=str+"\n";
            list=list+str;
        }
    ui->information->setText(list);
}

void MainWindow::on_incar_clicked()
{
    if(shop.find(ui->name_3->text())!=shop.end())
    {
        if(ui->number->value()>shop[ui->name_3->text()]->getnumber())
        {
           QMessageBox::information(this,"购买提示","库存中商品余量不足");
        }
        else
        {
            int pe=shop[ui->name_3->text()]->getnumber();
            int pr=ui->number->value();
            int c=pe-pr;
            shop[ui->name_3->text()]->setnumber(c);

            car[ui->name_3->text()]=shop[ui->name_3->text()];
            car[ui->name_3->text()]->setcarnumber(shop[ui->name_3->text()]->getcarnumber()+pr);
            QMessageBox::information(this,"购买提示","已成功加入购物车");
            ui->name_3->clear();
            ui->number->clear();
            QMap<QString ,Good*>::Iterator itt;
            int i=0;
            double total=0;
            for(itt=car.begin();itt!=car.end();itt++)
                {
                    item_model_2->setItem(i,0,new QStandardItem(QString("%1").arg(itt.value()->getname())));
                    item_model_2->setItem(i,1,new QStandardItem(QString("%1").arg(itt.value()->getcode())));
                    item_model_2->setItem(i,2,new QStandardItem(QString("%1").arg(itt.value()->getcarnumber())));
                    item_model_2->setItem(i,3,new QStandardItem(QString("%1").arg(itt.value()->getoutprice())));
                    item_model_2->setItem(i,4,new QStandardItem(QString("%1").arg(itt.value()->getsupplier())));
                    item_model_2->setItem(i,5,new QStandardItem(QString("%1").arg(itt.value()->getoutprice()*itt.value()->getcarnumber())));
                    i++;
                    total+=itt.value()->getoutprice()*itt.value()->getcarnumber();
                }

            QString str= QString::number(total);
            ui->totalprice->setText(str);
            QString list;
            QMap<QString ,Good*>::Iterator it;
            for(it=car.begin();it!=car.end();it++)
                {
                    QString str;
                    str=QString("商品名称：%1 条形码：%2 数量：%3 售价：%4 供应商：%5").arg(it.value()->getname()).arg(it.value()->getcode()).arg(it.value()->getcarnumber()).arg(it.value()->getoutprice()).arg(it.value()->getsupplier());
                    str=str+"\n";
                    list=list+str;
                }
            ui->cargoods->setText(list);
        }

    }
    else
        QMessageBox::information(this,"购买提示","库存中没有该商品");
 }

void MainWindow::on_paytotal_clicked()
{
    double earn=0;
    double total=0;
    QString str;
        QMap<QString ,Good*>::Iterator it;
    QString sb;
    QString spr;
    int number =0;
    for(it=car.begin();it!=car.end();it++)
    {
        number++;
    }
    if(number==0)
    {
      QMessageBox::information(this,"购买提示","购物车中未添加商品");
      return;
    }
    sb=QString("第%1次操作 ，").arg(count);
    water+=sb;
        for(it=car.begin();it!=car.end();it++)
            {
                earn=it.value()->getoutprice();
                total=total+earn*it.value()->getcarnumber();
                spr=QString("售货%1 ，数量%2 ，收款%3元").arg(it.value()->getname()).arg(it.value()->getcarnumber()).arg(it.value()->getcarnumber()*it.value()->getoutprice());
                water=water+spr+"\n";
                money=money+(it.value()->getoutprice()*it.value()->getcarnumber());
            }
        ui->list_2->setText(water);
        str= QString::number(total);
        QMessageBox::information(this,"购买提示","总计"+str+"元，欢迎下次光临");
        count++;
        //清空购物车
        car.clear();
        ui->cargoods->clear();
        for(it=shop.begin();it!=shop.end();it++)
            {
                it.value()->setcarnumber(0);
            }
        ui->totalprice->clear();
        item_model_2->clear();
        item_model_2 = new QStandardItemModel(8,4);  // 4行4列
        table_view_2->setModel(item_model_2);//两者关联
        QStringList column2, row2;//行列表头
        column2 << "商品名称" << "条形码" << "购买数量"  << "商品价格"  << "供应商" << "总计";
        row2 << "1" << "2" << "3" << "4";
        item_model_2->setHorizontalHeaderLabels(column2);                // 设置水平表头标签
        item_model_2->setVerticalHeaderLabels(row2);
        table_view_2->setEditTriggers(QTreeView::NoEditTriggers);


}

void MainWindow::on_findbtn_2_clicked()
{
    if(shop.find(ui->goodname_2->text())!=shop.end())
    {
        ui->barcode_2->setText(shop.find(ui->goodname_2->text()).value()->getcode());
        QString number =QString::number(shop.find(ui->goodname_2->text()).value()->getnumber());
        ui->amount_2->setText(number);
        QString inprice =QString::number(shop.find(ui->goodname_2->text()).value()->getinprice());
        ui->inprice->setText(inprice);
        QString outprice =QString::number(shop.find(ui->goodname_2->text()).value()->getoutprice());
        ui->outprice->setText(outprice);
        ui->sup_2->setText(shop.find(ui->goodname_2->text()).value()->getsupplier());
        QMessageBox::information(this,"查询提示","已为你查询到商品全部信息");
    }
    else
    {
        QMessageBox::information(this,"查询提示","库存中没有该商品");
    }
}

void MainWindow::on_changebtn_clicked()
{
    shop[ui->goodname_2->text()]->setcode(ui->barcode_2->text());
    shop[ui->goodname_2->text()]->setnumber(ui->amount_2->text().toInt());
    shop[ui->goodname_2->text()]->setinprice(ui->inprice->text().toDouble());
    shop[ui->goodname_2->text()]->setoutprice(ui->outprice->text().toDouble());
    shop[ui->goodname_2->text()]->setsupplier(ui->sup_2->text());
    QMessageBox::information(this,"修改提示",ui->goodname_2->text()+"商品信息已经修改");
}

void MainWindow::on_deletebtn_clicked()
{
    shop.erase(shop.find(ui->goodname_2->text()));
    ui->goodname_2->clear();
    ui->barcode_2->clear();
    ui->amount_2->clear();
    ui->inprice->clear();
    ui->outprice->clear();
    ui->sup_2->clear();
    QMessageBox::information(this,"修改提示",ui->goodname_2->text()+"商品已被删除");

}

void MainWindow::on_totalbtn_clicked()
{
    QString str =QString::number(money);
    ui->totaltext->setText(str);
    QMessageBox::information(this,"查询提示","已为你查询到今日的总收入");
}

void MainWindow::on_printbtn_clicked()
{
    QString filename = QFileDialog::getSaveFileName(this,"保存",QDir::currentPath(),"文本文件(*.txt)");
        if(filename.isEmpty())
        {
            QMessageBox::information(this,"提示","请输入正确的文件名");

        }
        QFile *file =new QFile;
        file->setFileName(filename);
        bool ok =file->open(QIODevice::WriteOnly);
        if(ok)
        {
            QTextStream out(file);
            QString text = ui->information->toPlainText();
            text.replace(QString ("\n"),QString("\r\n"));
            out<<text;
            file->close();
            delete file;
            QMessageBox::information(this,"提示","保存成功");
        }
        else
        {
            QMessageBox::information(this,"提示","保存失败");
        }
}

void MainWindow::on_printbtn_2_clicked()
{
    QString filename = QFileDialog::getSaveFileName(this,"保存",QDir::currentPath(),"文本文件(*.txt)");
        if(filename.isEmpty())
        {
            QMessageBox::information(this,"提示","请输入正确的文件名");

        }
        QFile *file =new QFile;
        file->setFileName(filename);
        bool ok =file->open(QIODevice::WriteOnly);
        if(ok)
        {
            QTextStream out(file);
            QString text = ui->list_2->toPlainText();
            text.replace(QString ("\n"),QString("\r\n"));
            out<<text;
            file->close();
            delete file;
            QMessageBox::information(this,"提示","保存成功");
        }
        else
        {
            QMessageBox::information(this,"提示","保存失败");
        }
}

void MainWindow::on_printbtn_3_clicked()
{
    QString filename = QFileDialog::getSaveFileName(this,"保存",QDir::currentPath(),"文本文件(*.txt)");
        if(filename.isEmpty())
        {
            QMessageBox::information(this,"提示","请输入正确的文件名");

        }
        QFile *file =new QFile;
        file->setFileName(filename);
        bool ok =file->open(QIODevice::WriteOnly);
        if(ok)
        {
            QTextStream out(file);
            QString text = ui->cargoods->toPlainText();
            text.replace(QString ("\n"),QString("\r\n"));
            out<<text;
            file->close();
            delete file;
            QMessageBox::information(this,"提示","保存成功");
        }
        else
        {
            QMessageBox::information(this,"提示","保存失败");
        }
}
void MainWindow:: paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPixmap pix;
    pix.load(":/photo/timg.jpg");
    painter.drawPixmap(0,0,this->width(),this->height(),pix);

    //  画背景上图标
    //  pix.load(":/photo/ziti.jpg_w800");
    //  缩放
    //  pix = pix.scaled(pix.width()*0.5,pix.height()*0.5);
    //  painter.drawPixmap(10,30,pix);
}
