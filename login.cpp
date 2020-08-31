#include "login.h"
#include "ui_login.h"
#include "mainwindow.h"
#include <QMessageBox>
#include<QPainter>
login::login(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::login)
{
    ui->setupUi(this);
}

login::~login()
{
    delete ui;
}

void login::on_pushButton_2_clicked()
{
    this->close();
}

void login::on_pushButton_clicked()
{
    QString username = ui->useredit->text();
        QString password = ui->passedit->text();
        if(username=="admin" && password=="123456")
        {
            QMessageBox::information(this,"登录提示","登录成功");
            this->close();
            MainWindow * t=new MainWindow;
            t->setWindowTitle("商店管理系统");
            t->show();

        }
        else
            {
            QMessageBox::information(this,"登录提示","用户名或密码错误");
            ui->useredit->clear();
            ui->passedit->clear();
            }
}
void login:: paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPixmap pix;
    pix.load(":/photo/u=3749878971,1630357328&fm=26&gp=0.jpg");
    painter.drawPixmap(0,0,this->width(),this->height(),pix);

    //  画背景上图标
    //  pix.load(":/photo/ziti.jpg_w800");
    //  缩放
    //  pix = pix.scaled(pix.width()*0.5,pix.height()*0.5);
    //  painter.drawPixmap(10,30,pix);
}
