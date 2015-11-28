#ifndef EDITOR_FAUSTVSTQT_H
#define EDITOR_FAUSTVSTQT_H

#include <QObject>
#include <aeffeditor.h>
#include <faust/gui/faustqt.h>

class VSTWrapper;

class Editor_faustvstqt : public QObject, public AEffEditor{
    Q_OBJECT

    VSTWrapper* effect;
    QScrollArea* widget;
    QTGUI* qtinterface;
    QWindow* hostWindow;

    // passiveControls: passive Kontrollelemente, die ständiges GUI-Update benötigen
    QVector<QObject*> passiveControls;

public:
    Editor_faustvstqt(VSTWrapper* effect);
    ~Editor_faustvstqt();

    // open(): öffnet die GUI
    virtual bool open(void *ptr);
    // getRect(): legt die Größe der GUI fest
    virtual bool getRect (ERect** rect);
    // idle(): Events werden hier abgefangen
    virtual void idle ();
    // close(): schließt die GUI
    virtual void close();

    float valueToVST(double value, double minimum, double maximum);
    void updateQTGUI(QObject* object, float value);

protected:
    ERect rectangle;

signals:
    void getVSTParameters(QObject* object);

public slots:
    void updateVST_buttonPressed();
    void updateVST_buttonReleased();
    void updateVST_checkBox();
    void updateVST();
    void updatePassiveControl(QObject* object);

};

#endif // EDITOR_FAUSTVSTQT_H
