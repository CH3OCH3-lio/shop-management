#include "mainwindow.h"
#include "login.h"
#include <QApplication>
#include<QPainter>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    login p;
    p.setWindowTitle("登录界面");
    p.setFixedSize(421,252);
    p.setWindowIcon(QIcon(":/photo/man.png"));
    p.show();
    return a.exec();
}
