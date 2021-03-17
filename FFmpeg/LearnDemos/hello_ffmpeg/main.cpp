#include "mainwindow.h"
#include <QApplication>
#include <QDebug>

// 必须使用这个extern包一层，否则会报错
// C++不能直接使用C语言函数，要使用这个包一层
extern "C" {
    #include <libavcodec/avcodec.h>
}


int main(int argc, char *argv[])
{
    qputenv("QT_SCALE_FACTOR", QByteArray("1"));

    qDebug() << av_version_info();

    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
