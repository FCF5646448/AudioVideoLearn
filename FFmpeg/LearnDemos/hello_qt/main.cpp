#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{

    // 消除警告®
    qputenv("QT_SCALE_FACTOR", QByteArray("1"));


    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
