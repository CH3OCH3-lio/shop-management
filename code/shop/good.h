#ifndef GOOD_H
#define GOOD_H

#include <QMainWindow>

class Good
{
private:
    QString name;
    QString code;
    int number;
    double inprice;
    double outprice;
    QString supplier;
    int carnumber;
public:
    Good(QString ,QString ,int ,double ,double ,QString);
    ~Good();
    void setname(QString);
    void setcode(QString);
    void setnumber(int);
    void setcarnumber(int);
    void setinprice(double);
    void setoutprice(double);
    void setsupplier(QString);
    QString getname();
    QString getcode();
    int getnumber();
    int getcarnumber();
    double getinprice();
    double getoutprice();
    QString getsupplier();
};

#endif // GOOD_H
