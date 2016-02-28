#ifndef EDITOR_FAUSTVSTQT_H
#define EDITOR_FAUSTVSTQT_H

#include <QObject>
#include <aeffeditor.h>
#include <faust/gui/faustqt.h>

class VSTWrapper;
#ifdef OSCCTRL
class OSCUI;
#endif
#ifdef HTTPCTRL
class httpdUI;
#endif

class Editor_faustvstqt : public QObject, public AEffEditor{
    Q_OBJECT

    VSTWrapper* effect;
    QScrollArea* widget;
    QTGUI* qtinterface;
#ifdef OSCCTRL
    OSCUI* oscinterface;
#endif
#ifdef HTTPCTRL
    httpdUI *httpdinterface;
#endif
    QWindow* hostWindow;

    // passiveControls: passive control elements needing continuous GUI update
    QVector<QObject*> passiveControls;

public:
    Editor_faustvstqt(VSTWrapper* effect);
    ~Editor_faustvstqt();

    // open(): opens the GUI
    virtual bool open(void *ptr);
    // getRect(): determines the size of the GUI
    virtual bool getRect (ERect** rect);
    // idle(): event processing is done here
    virtual void idle ();
    // close(): closes the GUI
    virtual void close();

    float valueToVST(double value, double minimum, double maximum);
    void updateQTGUI(QObject* object, float value);

protected:
    ERect rectangle;
    float voices_zone, tuning_zone;

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
