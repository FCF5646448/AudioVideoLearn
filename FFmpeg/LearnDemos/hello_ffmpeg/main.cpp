#include "mainwindow.h"
#include <QApplication>
#include <QDebug>

// 必须使用这个extern包一层，否则会报错
//#include <libavcodec/avcodec.h>
extern "C" {
    #include <libavcodec/avcodec.h>
}


int main(int argc, char *argv[])
{

    qDebug() << av_version_info();

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
