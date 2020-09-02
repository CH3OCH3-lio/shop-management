#include "mainwindow.h"
#include "login.h"
#include <QApplication>
#include<QPainter>
int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    login p;
    p.setWindowTitle("登陆");
    p.show();
    return a.exec();
}
