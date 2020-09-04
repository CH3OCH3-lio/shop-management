#include "good.h"
    Good::Good(QString name_,QString code_,int number_,double inprice_,double outprice_,QString supplier_)
    {
        name=name_;
        code=code_;
        number=number_;
        inprice=inprice_;
        outprice=outprice_;
        supplier=supplier_;
        carnumber=0;
    }
    Good::~Good()
    {

    }
    void Good::setname(QString name_)
    {
        name=name_;
    }
    void Good::setcode(QString code_)
    {
        code=code_;
    }
    void Good::setnumber(int number_)
    {
        number=number_;
    }
    void Good::setcarnumber(int carnumber_)
    {
        carnumber=carnumber_;
    }
    void Good::setinprice(double inprice_)
    {
        inprice=inprice_;
    }
    void Good::setoutprice(double outprice_)
    {
        outprice=outprice_;
    }
    void Good::setsupplier(QString supplier_)
    {
        supplier=supplier_;
    }



    QString Good::getname()
    {
        return name;
    }
    QString Good::getcode()
    {
        return code;
    }
    int Good::getnumber()
    {
        return number;
    }
    int Good::getcarnumber()
    {
        return carnumber;
    }
    double Good::getinprice()
    {
        return inprice;
    }
    double Good::getoutprice()
    {
        return outprice;
    }
    QString Good::getsupplier()
    {
        return supplier;
    }
