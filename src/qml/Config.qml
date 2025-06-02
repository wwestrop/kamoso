/*
    SPDX-FileCopyrightText: 2015 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.0
import KamosoQtGStreamer 1.0
import org.kde.kamoso 3.0
import org.kde.kirigami 2.9 as Kirigami

ColumnLayout {

    property int selectedCountdown: 0

    Kirigami.FormLayout {
        Kirigami.Heading {
            text: "Options"
            elide: Text.ElideRight
        }

        QQC2.ComboBox {
            id: countdownCombo
            textRole: "text"
            valueRole: "value"
            model: ListModel {
                ListElement { text: "(none)"; value: 0 }
                ListElement { text: "3s"; value: 3 }
                ListElement { text: "5s"; value: 5 }
                ListElement { text: "10s"; value: 10 }
            }
            Kirigami.FormData.label: i18n("Countdown")
            onActivated: selectedCountdown = currentValue
        }
    }

    GridView {
        id: view
        readonly property int columnCount: 3
        cellWidth: Math.floor(width / view.columnCount)
        cellHeight: cellWidth * 3 / 4

        Layout.fillHeight: true
        Layout.fillWidth: true

        header: QQC2.Control {
            height: effectsGalleryHeading.height + Kirigami.Units.largeSpacing
            Kirigami.Heading {
                id: effectsGalleryHeading
                level: 1
                color: Kirigami.Theme.textColor
                elide: Text.ElideRight
                text: i18n("Effects Gallery")
            }
        }

        QQC2.ScrollBar.vertical: QQC2.ScrollBar {}

        model: ListModel {
            ListElement {
                filters: "identity"
            }
            ListElement {
                filters: "bulge"
            }
            ListElement {
                filters: "frei0r-filter-cartoon"
            }
            ListElement {
                filters: "frei0r-filter-twolay0r"
            }
            //                 ListElement { filters: "frei0r-filter-color-distance" }
            ListElement {
                filters: "dicetv"
            }
            ListElement {
                filters: "frei0r-filter-distort0r"
            }
            ListElement {
                filters: "edgetv"
            }
            ListElement {
                filters: "coloreffects preset=heat"
            }
            ListElement {
                filters: "videobalance saturation=0 ! agingtv"
            }
            ListElement {
                filters: "videobalance saturation=1.5 hue=-0.5"
            }
            //                 ListElement { filters: "frei0r-filter-invert0r" }
            ListElement {
                filters: "kaleidoscope"
            }
            ListElement {
                filters: "videobalance saturation=1.5 hue=+0.5"
            }
            ListElement {
                filters: "mirror"
            }
            ListElement {
                filters: "videobalance saturation=0"
            }
            ListElement {
                filters: "optv"
            }
            ListElement {
                filters: "pinch"
            }
            ListElement {
                filters: "quarktv"
            }
            ListElement {
                filters: "radioactv"
            }
            ListElement {
                filters: "revtv"
            }
            ListElement {
                filters: "rippletv"
            }
            ListElement {
                filters: "videobalance saturation=2"
            }
            ListElement {
                filters: "coloreffects preset=sepia"
            }
            ListElement {
                filters: "shagadelictv"
            }
            //                 ListElement { filters: "frei0r-filter-sobel" }
            ListElement {
                filters: "square"
            }
            ListElement {
                filters: "streaktv"
            }
            ListElement {
                filters: "stretch"
            }
            ListElement {
                filters: "frei0r-filter-delay0r delaytime=1"
            }
            ListElement {
                filters: "twirl"
            }
            ListElement {
                filters: "vertigotv"
            }
            ListElement {
                filters: "warptv"
            }
            ListElement {
                filters: "coloreffects preset=xray"
            }
        }


        property string sampleImage: ""
        onVisibleChanged: if (view.visible) {
            webcam.sampleImage
            delayedUpdateTimer.restart()
        }

        Timer {
            id: delayedUpdateTimer
            interval: 500
            repeat: false
            onTriggered: {
                view.sampleImage = webcam.sampleImage;
            }
        }

        delegate: Rectangle {
            readonly property int borderWidth: 2
            id: delegateItem

            width: Math.floor(view.width / view.columnCount) - Kirigami.Units.smallSpacing
            height: width * 3 / 4

            color: devicesModel.playingDevice.filters === model.filters ? Kirigami.Theme.highlightColor : Kirigami.Theme.textColor

            MouseArea {
                anchors.centerIn: parent

                width: delegateItem.width - (borderWidth * 2)
                height: delegateItem.height - (borderWidth * 2)

                VideoItem {
                    anchors.fill: parent

                    PipelineItem {
                        id: pipe

                        playing: false
                        onFailed: {
                            delegateItem.visible = false
                            view.model.remove(index)
                        }

                        description: view.sampleImage.length === 0 ? "" : "filesrc location=\"" + view.sampleImage + "\" ! decodebin ! imagefreeze ! videoconvert ! " + model.filters + " name=last"
                    }
                    surface: pipe.surface
                }

                onClicked: {
                    if (devicesModel.playingDevice.filters === model.filters)
                        devicesModel.playingDevice.filters = ""
                    else
                        devicesModel.playingDevice.filters = model.filters
                }
            }
        }
    }
}