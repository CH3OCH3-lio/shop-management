#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMap>
#include <good.h>
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
QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
 void paintEvent(QPaintEvent *);
 QTableView * table_view;
 QStandardItemModel * item_model;
 QTableView * table_view_2;
 QStandardItemModel * item_model_2;
 void inittable();
private:
    Ui::MainWindow *ui;
    QMap<QString ,Good *> shop;
    QMap<QString ,Good *> car;
private slots:
    void in_();
    void stock_();
    void income_();
    void sale_();
    void change_();
    void on_input_clicked();
    void on_findbtn_clicked();
    void on_pushButton_clicked();
    void on_incar_clicked();
    void on_paytotal_clicked();
    void on_findbtn_2_clicked();
    void on_changebtn_clicked();
    void on_deletebtn_clicked();
    void on_totalbtn_clicked();
    void on_printbtn_clicked();
    void on_printbtn_2_clicked();
    void on_printbtn_3_clicked();
};
#endif // MAINWINDOW_H
